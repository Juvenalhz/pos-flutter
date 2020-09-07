part of 'initialization_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState();
}

class InitializationInitial extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationConnecting extends InitializationState {
  Comm comm;

  InitializationConnecting(this.comm);

  @override
  List<Object> get props => [comm];
}

class InitializationSending extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationReceiving extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationCompleted extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationFailed extends InitializationState {
  @override
  List<Object> get props => [];
}
