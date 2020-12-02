import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/utils/communication.dart';

part 'echo_test_event.dart';
part 'echo_test_state.dart';

class EchoTestBloc extends Bloc<EchoTestEvent, EchoTestState> {
  EchoTestBloc() : super(EchoTestInitial());
  Comm comm;
  Communication connection;
  EchoTestMessage echoTest;

  @override
  Stream<EchoTestState> mapEventToState(
    EchoTestEvent event,
  ) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    if (event is EchoTestInitialEvent)
      yield EchoTestInitial();
    else if (event is EchoTestConnect) {
      comm = event.comm;
      echoTest = new EchoTestMessage(comm);

      yield EchoTestConnecting(comm);

      //TODO: change the connection to use secure connection
      connection = new Communication(comm.ip, comm.port, false, comm.timeout);

      if ((isDev == true) && (isCommOffline == true)) {
        this.add(EchoTestSend());
        yield EchoTestSending();
      }
      else if (await connection.connect() == true) {
        this.add(EchoTestSend());
        yield EchoTestSending();
      } else {
        yield EchoTestCommError();
      }
    }
    else if (event is EchoTestSend) {
      if ((isDev == true) && (isCommOffline == true))
        await echoTest.buildMessage();
      else
        connection.sendMessage(await echoTest.buildMessage());

      incrementStan();
      this.add(EchoTestReceive());
      yield EchoTestReceiving();
    }
    else if (event is EchoTestReceive) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response  == null){
        yield EchoTestShowMessage('Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        yield EchoTestFailed('Error En Prueba De Comunicación');
      }
      else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await echoTest.parseRenponse(response);
        if (respMap[39] == '00') {
          if (respMap[6208] != null)
            yield EchoTestCompleted(respMap[6208]);
          else
            yield EchoTestCompleted('Prueba De Comunicación OK');
        }
        else  // error in echo test response
          yield EchoTestFailed('Error En Prueba De Comunicación');
      }
      connection.disconnect();
    }
  }
}
