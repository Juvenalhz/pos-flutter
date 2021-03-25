part of 'initialization_bloc.dart';

class Host {
  String _address;
  int _port;

  Host(this._address, this._port);

  String get address => this._address;
  int get port => this._port;
}

abstract class InitializationEvent extends Equatable {
  const InitializationEvent();

  @override
  List<Object> get props => [];
}

class InitializationInitialEvent extends InitializationEvent {
  @override
  List<Object> get props => [];
}

class InitializationConnect extends InitializationEvent {
  final Comm comm;

  InitializationConnect(this.comm);

  @override
  List<Object> get props => [this.comm];
}

class InitializationSend extends InitializationEvent {
  @override
  List<Object> get props => [];
}

class InitializationReceive extends InitializationEvent {
  @override
  List<Object> get props => [];
}

class InitializationProcess extends InitializationEvent {
  @override
  List<Object> get props => [];
}
