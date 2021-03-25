part of 'echo_test_bloc.dart';

abstract class EchoTestState extends Equatable {
  const EchoTestState();
}

class EchoTestInitial extends EchoTestState {
  @override
  List<Object> get props => [];
}


class EchoTestConnecting extends EchoTestState {
  final Comm comm;

  EchoTestConnecting(this.comm);

  @override
  List<Object> get props => [comm];
}

class EchoTestSending extends EchoTestState {
  @override
  List<Object> get props => [];
}

class EchoTestReceiving extends EchoTestState {
  @override
  List<Object> get props => [];
}

class EchoTestCompleted extends EchoTestState {
  final String message;

  EchoTestCompleted(this.message);

  @override
  List<Object> get props => [message];
}

class EchoTestFailed extends EchoTestState {
  final String message;

  EchoTestFailed(this.message);

  @override
  List<Object> get props => [message];
}

class EchoTestCommError extends EchoTestState {
  @override
  List<Object> get props => [];
}

class EchoTestShowMessage extends EchoTestState {
  final String message;

  EchoTestShowMessage(this.message);

  @override
  List<Object> get props => [message];
}
