import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/trans.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());
  var trans = new Trans();
  TransactionEvent lastEvent;
  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is TransactionInitial) {
      yield TransactionAddAmount(trans);
    } else if (event is TransAddAmount) {
      trans.baseAmount = event.amount;
      yield TransactionAddTip(trans);
    } else if (event is TransAddTip) {
      trans.tip = event.tip;
    } else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation();
    }
    lastEvent = event;
  }
}
