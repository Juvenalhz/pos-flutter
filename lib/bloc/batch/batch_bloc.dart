import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/dataUtils.dart';
import 'package:pay/utils/receipt.dart';

part 'batch_event.dart';

part 'batch_state.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  MerchantRepository merchantRepository = new MerchantRepository();
  AcquirerRepository acquirerRepository = new AcquirerRepository();
  TransRepository transRepository = new TransRepository();
  CommRepository commRepository = new CommRepository();
  Merchant merchant;
  Acquirer acquirer;
  Communication connection;
  ReversalMessage reversalMessage;
  Comm comm;
  BatchMessage batchMessage;
  int batchStan;
  String strMessage;
  int newBatch;
  String AprobMessage;

  BatchBloc() : super(BatchInitial());

  @override
  Stream<BatchState> mapEventToState(BatchEvent event) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    print(event.toString());
    if (event is BatchInitialEvent) {
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

      if (await transRepository.getCountTrans(where: 'reverse = 0') == 0)
        yield BatchEmpty();
      else if(!acquirer.industryType)
        yield BatchConfirm();
      else
        this.add(BatchCheckAdjustedTips());
    }
    else if (event is BatchCheckAdjustedTips) {
      List<Map<String, dynamic>> acquirers = await acquirerRepository.getAllacquirers(where: 'industryType = 1');
      if (acquirers.length > 0) {
        List<Map<String, dynamic>> transNotAdjusted =
        await transRepository.getAllTrans(where: 'binType = 1 and tipAdjusted = 0 and reverse = 0  and voided = 0 and type<>\'Anulación\'');

        if (transNotAdjusted.length > 0) {
          yield BatchMissingTipAdjust();
        }else
          yield BatchConfirm();
      }
    } else if (event is BatchCancel) {
      yield BatchFinish();
    } else if (event is BatchMissingTipsOk) {
      yield BatchConfirm();
    } else if (event is BatchConfirmOk) {
      comm = Comm.fromMap(await commRepository.getComm(1));
      connection = new Communication(comm.ip, comm.port, true, comm.timeout);

      yield BatchConnecting();

      if ((isDev == true) && (isCommOffline == true))
        this.add(BatchSendReversal());
      else if (await connection.connect() == true) {
        this.add(BatchSendReversal());
        yield BatchSending();
      } else {
        yield BatchCommError();
      }
    } else if (event is BatchSendReversal) {
      if (await transRepository.getCountReversal() != 0) {
        Trans transReversal = Trans.fromMap(await transRepository.getTransReversal());
        reversalMessage = new ReversalMessage(transReversal, comm);

        if ((isDev == true) && (isCommOffline == true))
          await reversalMessage.buildMessage();
        else
          connection.sendMessage(await reversalMessage.buildMessage());

        this.add(BatchReceiveReversal(transReversal));
        yield BatchReceiving();
      } else {
        this.add(BatchSendRequest());
        yield BatchSending();
      }
    }
    // reversal response
    else if (event is BatchReceiveReversal) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response == null) {
        yield BatchShowMessage('Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        this.add(BatchCancel());
      } else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await reversalMessage.parseRenponse(response, trans: event.transReversal);
        if (respMap[39] == '00') {
          await transRepository.deleteTrans(event.transReversal.id);
          this.add(BatchSendRequest());
          yield BatchSending();
        } else // error in reversal
          this.add(BatchInitialEvent());
      }
    }
    // send request
    else if (event is BatchSendRequest) {
      yield BatchSending();

      int countSale = await transRepository.getCountSale();
      int countVoid = await transRepository.getCountVoid();
      int totalSale = await transRepository.getBatchTotal(where: 'reverse=0 and voided=0');
      int totalVoid = (countVoid != 0) ? await transRepository.getTotalVoid() : 0;

      batchStan = await getStan();
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

      batchMessage = new BatchMessage(comm, merchant.batchNumber, countSale, totalSale, countVoid, totalVoid);
      if ((isDev == true) && (isCommOffline == true))
        await batchMessage.buildMessage();
      else
        connection.sendMessage(await batchMessage.buildMessage());

      incrementStan();
      this.add(BatchReceive());
      yield BatchReceiving();
    }
    // received response message and parse it
    else if (event is BatchReceive) {
      Uint8List response;

      if (isCommOffline == false) {
        response = await connection.receiveMessage();
        if (response == null) {
          yield BatchShowMessage('Error - Timeout de comunicación');
          await new Future.delayed(const Duration(seconds: 3));
          this.add(BatchCancel());
        }
      }
      if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap;

        respMap = await batchMessage.parseRenponse(response);

        this.add(BatchProcessResponse(respMap));
      }
      connection.disconnect();
    } else if (event is BatchProcessResponse) {
      MerchantRepository merchantRepository = new MerchantRepository();
      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

      if ((event.respMap[11] == null) ||
          (batchStan != int.parse(event.respMap[11])) ||
          (event.respMap[41] == null) ||
          (merchant.tid.padLeft(8, '0') != event.respMap[41])) {
        // reversal is stored in the DB
        yield BatchError('Error en Respuesta');
        await new Future.delayed(const Duration(seconds: 3));
        this.add(BatchCancel());
      } else {
        if (event.respMap[39] != null) {
          if ((event.respMap[39] == '00') || (event.respMap[39] == '95')) {
            Receipt receipt = new Receipt();

            AprobMessage = event.respMap[39];
            strMessage = event.respMap[6208];
            yield BatchPrintDetailReport();

            if (event.respMap[6202] != null) newBatch = int.parse(event.respMap[6202]);
          } else {
            yield BatchError(event.respMap[6208]);
          }
        }
      }
    } else if (event is BatchComplete) {
      if (newBatch != null) merchant.batchNumber = newBatch;
      merchantRepository.updateMerchant(merchant);

      await transRepository.deleteAllTrans();
      if (AprobMessage == '00')
        yield BatchOK(strMessage + '\n\n\nLote Cerrado');
      else
        yield BatchNotInBalance(strMessage);
    } else if (event is BatchDone) {
      yield BatchFinish();
    }
  }
}
