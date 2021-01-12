import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/pinpad.dart';

part 'tech_visit_event.dart';
part 'tech_visit_state.dart';

class TechVisitBloc extends Bloc<TechVisitEvent, TechVisitState> {
  TechVisitBloc() : super(TechVisitInitial());
  Pinpad pinpad;
  Comm comm;
  Communication connection;
  TechVisitMessage techVisitMessage;
  String track2;
  int visitType;
  int requirementType;
  String pinBlock;
  String pinKSN;

  @override
  Stream<TechVisitState> mapEventToState(
    TechVisitEvent event,
  ) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    if (event is TechVisitInitialEvent) {
      yield TechVisitGetCard();
      this.add(TechVisitCardRead());
    } else if (event is TechVisitInitPinpad) {
      pinpad = event.pinpad;
    } else if (event is TechVisitCardRead) {
      yield TechVisitAskVisitType();
    } else if (event is TechVisitAddVisitType) {
      visitType = event.visitType;
      yield TechVisitAskRequirementType();
    } else if (event is TechVisitAddRequirementType) {
      TerminalRepository terminalRepository = new TerminalRepository();
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
      String pan;
      requirementType = event.requirementType;

      yield TechVisitShowPinMessage();
      await pinpad.askPin(terminal.keyIndex, pan, '', '', 'techVisit'); // parameter 3 and 4 are not shown by the BC library
    } else if (event is TechVisitPinEntered) {
      CommRepository commRepository = new CommRepository();
      Comm comm = Comm.fromMap(await commRepository.getComm(1));
      if (event.pinData['PINBlock'] != null) {
        pinBlock = event.pinData['PINBlock'];
      }
      if (event.pinData['PINKSN'] != null) {
        pinKSN = event.pinData['PINKSN'];
      }
      this.add(TechVisitConnect(comm));
      yield TechVisitConnecting();
    } else if (event is TechVisitAddRequirementBack) {
      visitType = 0;
      yield TechVisitAskVisitType();
    } else if (event is TechVisitConnect) {
      comm = event.comm;
      techVisitMessage = new TechVisitMessage(comm);

      yield TechVisitConnecting();

      connection = new Communication(comm.ip, comm.port, true, comm.timeout);

      if ((isDev == true) && (isCommOffline == true)) {
        this.add(TechVisitSend());
        yield TechVisitSending();
      } else if (await connection.connect() == true) {
        this.add(TechVisitSend());
        yield TechVisitSending();
      } else {
        yield TechVisitCommError();
      }
    } else if (event is TechVisitSend) {
      if ((isDev == true) && (isCommOffline == true))
        await techVisitMessage.buildMessage(track2, visitType, requirementType, pinBlock, pinKSN);
      else
        connection.sendMessage(await techVisitMessage.buildMessage(track2, visitType, requirementType, pinBlock, pinKSN));

      incrementStan();
      this.add(TechVisitReceive());
      yield TechVisitReceiving();
    } else if (event is TechVisitReceive) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response == null) {
        yield TechVisitShowMessage('Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        yield TechVisitFailed('Error En Prueba De Comunicación');
      } else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await lastSale.parseRenponse(response);
        if (respMap[39] == '00') {
          var trans = new Trans();
          BinRepository binRepository = new BinRepository();
          int binId = await binRepository.getBinId(respMap[2].substring(0, 8));
          Bin bin = Bin.fromMap(await binRepository.getBin(binId));
          int lastTransState = int.parse(respMap[6220].substring(0, 1));
          int lastTransType = int.parse(respMap[6220].substring(1, 2));
          int lastTransDay = int.parse(respMap[6220].substring(3, 5));
          int lastTransMonth = int.parse(respMap[6220].substring(5, 7));
          int lastTransYear = 2000 + int.parse(respMap[6220].substring(7, 9));

          trans.type = 'Venta';

          if (lastTransState == 0)
            trans.respCode = '00';
          else if (lastTransState == 2)
            trans.respCode = '01';
          else if (lastTransState == 1) {
            trans.type = 'Anulación';
            trans.respCode = '00';
          }

          trans.bin = binId;
          trans.binType = bin.cardType;

          trans.total = int.parse(respMap[4]);
          trans.maskedPAN = respMap[2].substring(0, 4) + '....' + respMap[2].substring(respMap[2].length - 4);

          trans.stan = int.parse(respMap[6201]);

          if (respMap[62.02] != null) trans.batchNum = int.parse(respMap[62.02]);

          trans.dateTime = DateTime(lastTransYear, lastTransMonth, lastTransDay, int.parse(respMap[12].substring(0, 2)),
              int.parse(respMap[12].substring(2, 4)), int.parse(respMap[12].substring(4, 6)));

          trans.referenceNumber = respMap[37];
          trans.authCode = respMap[38];
          trans.respMessage = respMap[6208];

          if (respMap[6216] != null) trans.foodBalance = int.parse(respMap[6216]);

          yield TechVisitCompleted(trans, bin.brand);
        } else // error in echo test response
          yield TechVisitFailed('Error En Prueba De Comunicación');
      }
      connection.disconnect();
    }
  }
}
