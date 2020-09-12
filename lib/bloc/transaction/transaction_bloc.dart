import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());
  var trans = new Map<String, dynamic>();

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is TransactionInitial) {
      yield TransactionAddAmount();
    } else if (event is TransAddAmount) {
      yield TransactionAddTip();
    } else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation();
    }
  }
}
