import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/utils/communication.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(InitializationInitial());
  Comm comm;
  Communication connection;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is InitializationConnect) {
      comm = event.comm;
      connection = new Communication(comm.ip, comm.port, false);
      await connection.connect();
      this.add(InitializationSend());
    } else if (event is InitializationSend) {
      MessageInitialization initialization = new MessageInitialization(comm);
      connection.sendMessage(await initialization.buildMessage());
    } else {
      print(event);
    }
  }
}
