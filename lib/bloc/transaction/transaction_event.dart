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
  @override
  List<Object> get props => [];
}

class TransBack extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransLoadEmvTables extends TransactionEvent {
  Pinpad pinpad;

  TransLoadEmvTables(this.pinpad);

  @override
  List<Object> get props => [this.pinpad];
}

class TransWaitEmvTablesLoaded extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransGetCard extends TransactionEvent {
  final Trans trans;

  const TransGetCard([this.trans]);

  @override
  List<Object> get props => [this.trans];
}
