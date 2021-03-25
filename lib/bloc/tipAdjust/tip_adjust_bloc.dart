import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/receipt.dart';
import 'package:pay/utils/reports.dart';

part 'tip_adjust_event.dart';
part 'tip_adjust_state.dart';

class TipAdjustBloc extends Bloc<TipAdjustEvent, TipAdjustState> {
  var trans = new Trans();
  static Communication connection;
  CommRepository commRepository = new CommRepository();
  TransRepository transRepository = new TransRepository();
  ReversalMessage reversalMessage;
  AdjustMessage adjustMessage;
  BuildContext context;

  TipAdjustBloc(this.context) : super(TipAdjustInitial());

  @override
  Stream<TipAdjustState> mapEventToState(
    TipAdjustEvent event,
  ) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    if (event is TipAdjustInitialEvent) {
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'binType = 1 and reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      yield TipAdjustDataReady(listTrans);
    } else if (event is TipAdjustAskTip) {
      trans = event.trans;
      if (trans.tipAdjusted == false) {
        yield TipAdjustPromptTip(event.trans);
      } else {
        this.add(TipAdjustInitialEvent());
      }
    } else if (event is TipAdjustAddTip) {
      if (trans.baseAmount + event.tip <= trans.originalTotal) {
        trans.tip = event.tip;
        trans.total = trans.baseAmount + trans.tip;
        yield TipAdjustConfirmation(trans);
      } else {
        yield TipAdjustShowMessage(trans, 'Promina Exede El Monto Maximo Permitido');
      }
    } else if (event is TipAdjustConfirmOK) {
      this.add(TipAdjustConnect());
    }
    // Connect
    else if (event is TipAdjustConnect) {
      Comm comm = Comm.fromMap(await commRepository.getComm(1));
      connection = new Communication(comm.ip, comm.port, true, comm.timeout);

      yield TipAdjustConnecting();

      if ((isDev == true) && (isCommOffline == true))
        this.add(TipAdjustSendReversal());
      else if (await connection.connect() == true) {
        this.add(TipAdjustSendReversal());
        yield TipAdjustSending();
      } else {
        yield TipAdjustCommError();
      }
    } else if (event is TipAdjustSendReversal) {
      if (await transRepository.getCountReversal() != 0) {
        Trans transReversal = Trans.fromMap(await transRepository.getTransReversal());
        Comm comm = Comm.fromMap(await commRepository.getComm(1));

        reversalMessage = new ReversalMessage(transReversal, comm);

        if ((isDev == true) && (isCommOffline == true))
          await reversalMessage.buildMessage();
        else
          connection.sendMessage(await reversalMessage.buildMessage());

        this.add(TipAdjustReceiveReversal(transReversal));
        yield TipAdjustReceiving();
      } else {
        this.add(TipAdjustSendRequest());
        yield TipAdjustSending();
      }
    }
    // reversal response
    else if (event is TipAdjustReceiveReversal) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response == null) {
        trans.clear();
        yield TipAdjustShowMessage(trans, 'Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        this.add(TipAdjustInitialEvent());
      } else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await reversalMessage.parseRenponse(response, trans: trans);
        if (respMap[39] == '00') {
          await transRepository.deleteTrans(event.transReversal.id);
          this.add(TipAdjustSendRequest());
          yield TipAdjustSending();
        } else // error in reversal
          this.add(TipAdjustInitialEvent());
      }
    }
    // send request
    else if (event is TipAdjustSendRequest) {
      Comm comm = Comm.fromMap(await commRepository.getComm(1));

      yield TipAdjustSending();
      trans.stan = await getStan();
      adjustMessage = new AdjustMessage(trans, comm);
      if ((isDev == true) && (isCommOffline == true))
        await adjustMessage.buildMessage();
      else
        connection.sendMessage(await adjustMessage.buildMessage());

      incrementStan();
      this.add(TipAdjustReceive());
      yield TipAdjustReceiving();
    }
    // received response message and parse it
    else if (event is TipAdjustReceive) {
      Uint8List response;

      if (isCommOffline == false) {
        response = await connection.receiveMessage();
        if (response == null) {
          trans.clear();
          yield TipAdjustShowMessage(trans, 'Error - Timeout de comunicación');
          await new Future.delayed(const Duration(seconds: 3));
          this.add(TipAdjustInitialEvent());
        }
      }
      if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap;

        respMap = await adjustMessage.parseRenponse(response, trans: trans);

        this.add(TipAdjustProcessResponse(respMap));
      }
      connection.disconnect();
    }
    // analyze response fields
    else if (event is TipAdjustProcessResponse) {
      MerchantRepository merchantRepository = new MerchantRepository();
      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

      if ((event.respMap[4] == null) ||
          (trans.total != int.parse(event.respMap[4])) ||
          (event.respMap[11] == null) ||
          (trans.stan != int.parse(event.respMap[11])) ||
          (event.respMap[41] == null) ||
          (merchant.tid.padLeft(8, '0') != event.respMap[41])) {
        // reversal is stored in the DB
        trans.respMessage = 'Error En Respuesta';
        yield TipAdjustRejected(trans);
      } else {
        if (event.respMap[39] != null) trans.respCode = event.respMap[39];

        if (trans.respCode == '00') {
          Receipt receipt = new Receipt();

          if (event.respMap[37] != null) trans.referenceNumber = event.respMap[37];
          if (event.respMap[38] != null) trans.authCode = event.respMap[38];
          if (event.respMap[55] != null) trans.responseEmvTags = event.respMap[55];
          trans.tipAdjusted = true;

          transRepository.updateTrans(trans);
          receipt.tipAdjustReceipt(trans, onPrintOk, onPrintError);

          yield TipAdjustCompleted(trans);
        } else {
          trans.respMessage = event.respMap[6208];
          yield TipAdjustRejected(trans);
        }
      }
    }
  }

  void onPrintOk() async {}

  void onPrintError(int type) {}
}
