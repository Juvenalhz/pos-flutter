part of 'initialization_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState();
}

class InitializationInitial extends InitializationState {
  @override
  List<Object> get props => [];
}

class InitializationConnecting extends InitializationState {
  final String address;
  final String port;

  InitializationConnecting(this.address, this.port);

  @override
  List<Object> get props => [address, port];
}

class InitializationSending extends InitializationState {
  @override
  List<Object> get props => [];
}
