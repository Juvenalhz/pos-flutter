import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/terminal.dart';

@immutable
abstract class TerminalState extends Equatable {
  const TerminalState();
}

class TerminalInitial extends TerminalState {
  @override
  List<Object> get props => [];
}

class TerminalLoading extends TerminalState {
  @override
  List<Object> get props => [];
}

class TerminalMissing extends TerminalState {
  @override
  List<Object> get props => [];
}

class TerminalGet extends TerminalState {
  final int id;

  const TerminalGet({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class TerminalDelete extends TerminalState {
  final int id;

  const TerminalDelete({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class TerminalLoaded extends TerminalState {
  final Terminal terminal;

  const TerminalLoaded({@required this.terminal}) : assert(terminal != null);

  @override
  List<Object> get props => [terminal];
}
