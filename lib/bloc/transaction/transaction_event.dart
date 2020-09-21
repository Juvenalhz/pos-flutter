part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransAddAmount extends TransactionEvent {
  final int amount;

  const TransAddAmount([this.amount]);
}

class TransAddTip extends TransactionEvent {
  final int tip;

  const TransAddTip([this.tip]);
}

class TransAskConfirmation extends TransactionEvent {
  Trans trans;

  TransAskConfirmation(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransBack extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransConfirmOK extends TransactionEvent {
  @override
  List<Object> get props => [];
}
