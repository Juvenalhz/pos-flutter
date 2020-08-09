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

class InitializationConnect extends InitializationEvent {
  final String address;
  final int port;

  InitializationConnect(this.address, this.port);

  @override
  List<Object> get props => [this.address, this.port];
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
