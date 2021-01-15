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
      yield TechVisitInitial();
    } else if (event is TechVisitInitPinpad) {
      pinpad = event.pinpad;
      yield TechVisitGetCard();
      this.add(TechVisitCardRead());
    } else if (event is TechVisitCardRead) {
      yield TechVisitAskVisitType();
    } else if (event is TechVisitAddVisitType) {
      visitType = event.visitType;
      yield TechVisitAskRequirementType();
    } else if (event is TechVisitAddRequirementType) {
      TerminalRepository terminalRepository = new TerminalRepository();
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
      track2 = '4540422020094301=190720118753445';
      String pan = track2.substring(0, track2.indexOf('='));
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
        Map<int, String> respMap = await techVisitMessage.parseRenponse(response);
        if (respMap[39] == '00') {
          yield TechVisitCompleted(respMap[6208]);
        } else // error in echo test response
          yield TechVisitFailed('Error En Prueba De Comunicación');
      }
      connection.disconnect();
    }
  }
}
