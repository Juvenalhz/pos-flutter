import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/models/trans.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());
  var trans = new Trans();

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is TransactionInitial) {
      yield TransactionAddAmount(trans);
    } else if (event is TransAddAmount) {
      trans.baseAmount = event.amount;
      trans.total += event.amount;
      yield TransactionAddTip(trans);
    } else if (event is TransAskAmount) {
      trans.baseAmount = event.amount;
      trans.tip = 0;
      yield TransactionAddAmount(trans);
    } else if (event is TransAddTip) {
      trans.tip = event.tip;
      trans.total += event.tip;
      this.add(TransAskConfirmation(trans));
    } else if (event is TransAskTip) {
      trans.tip = event.tip;
      yield TransactionAddTip(trans);
    } else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation(trans);
    }
  }
}
