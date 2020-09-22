import 'package:equatable/equatable.dart';
import 'package:pay/models/emv.dart';

abstract class EmvEvent extends Equatable {
  const EmvEvent();

  @override
  List<Object> get props => [];
}

class EmvLoadInProgress extends EmvEvent {}

class EmvLoadSuccess extends EmvEvent {
  final Emv emv;

  const EmvLoadSuccess([this.emv]);

  @override
  List<Object> get props => [emv];

  @override
  String toString() => 'EmvLoadSuccess { emv: $emv }';
}

class GetEmv extends EmvEvent {
  final int id;

  const GetEmv([this.id]);
}

class EmvLoadFailure extends EmvEvent {}

class EmvTerminal extends EmvEvent {
  final int id;

  const EmvTerminal([this.id]);
}

class UpdateEmv extends EmvEvent {
  final Emv terminal;

  const UpdateEmv(this.terminal);
}
