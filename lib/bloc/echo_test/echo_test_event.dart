part of 'echo_test_bloc.dart';

abstract class EchoTestEvent extends Equatable {
  const EchoTestEvent();
}

class EchoTestInitialEvent extends EchoTestEvent {
  @override
  List<Object> get props => [];
}

class EchoTestConnect extends EchoTestEvent {
  final Comm comm;

  EchoTestConnect(this.comm);

  @override
  List<Object> get props => [this.comm];
}

class EchoTestSend extends EchoTestEvent {
  @override
  List<Object> get props => [];
}

class EchoTestReceive extends EchoTestEvent {
  @override
  List<Object> get props => [];
}

class EchoTestProcess extends EchoTestEvent {
  @override
  List<Object> get props => [];
}

