import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/utils/communication.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(InitializationInitial());

  Communication connection;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is InitializationConnect) {
      connection = new Communication(event.address, event.port, false);
      await connection.connect();
      this.add(InitializationSend());
    } else if (event is InitializationSend) {
      Uint8List testmessage = new Uint8List.fromList([0, 3, 3, 4, 5]);
      connection.sendMessage(testmessage);
    } else {
      print(event);
    }
  }
}
