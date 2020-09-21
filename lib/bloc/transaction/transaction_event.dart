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

class TransAskAmount extends TransactionEvent {
  final int amount;

  const TransAskAmount([this.amount]);
}

class TransAddTip extends TransactionEvent {
  final int tip;

  const TransAddTip([this.tip]);
}

class TransAskTip extends TransactionEvent {
  final int tip;

  const TransAskTip([this.tip]);
}

class TransAskConfirmation extends TransactionEvent {
  final Trans trans;

  TransAskConfirmation(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransConfirmOK extends TransactionEvent {
  @override
  List<Object> get props => [];
}
