import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'terminal_event.dart';
import 'terminal_state.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  final TerminalRepository terminalRepository;

  TerminalBloc({@required this.terminalRepository}) : super(null);

  @override
  TerminalState get initialState => TerminalInitial();

  @override
  Stream<TerminalState> mapEventToState(TerminalEvent event) async* {
    yield TerminalLoading();

    if (event is GetTerminal) {
      int numTerminals = await terminalRepository.getCountTerminals();

      if (numTerminals == 0) {
        yield TerminalMissing();
      } else {
        Map<String, dynamic> terminalMap = await terminalRepository.getTerminal(event.id);
        Terminal terminal = new Terminal.fromMap(terminalMap);

        if (terminal == null) yield TerminalLoading();

        yield TerminalLoaded(terminal: terminal);
      }
    } else if (event is UpdateTerminal) {
      yield TerminalLoading();
      await terminalRepository.updateTerminal(event.terminal);
      yield TerminalGet(id: event.terminal.id);
    }
  }
}
