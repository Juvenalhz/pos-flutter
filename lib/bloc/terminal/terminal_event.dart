import 'package:equatable/equatable.dart';
import 'package:pay/models/terminal.dart';

abstract class TerminalEvent extends Equatable {
  const TerminalEvent();

  @override
  List<Object> get props => [];
}

class TerminalLoadInProgress extends TerminalEvent {}

class TerminalLoadSuccess extends TerminalEvent {
  final Terminal terminal;

  const TerminalLoadSuccess([this.terminal]);

  @override
  List<Object> get props => [terminal];

  @override
  String toString() => 'TerminalLoadSuccess { terminal: $terminal }';
}

class GetTerminal extends TerminalEvent {
  final int id;

  const GetTerminal([this.id]);
}

class TerminalLoadFailure extends TerminalEvent {}

class DeleteTerminal extends TerminalEvent {
  final int id;

  const DeleteTerminal([this.id]);
}

class UpdateTerminal extends TerminalEvent {
  final Terminal terminal;

  const UpdateTerminal(this.terminal);
}
