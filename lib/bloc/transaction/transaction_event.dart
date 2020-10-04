part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransStartTransaction extends TransactionEvent {
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
  Pinpad pinpad;

  TransConfirmOK(this.pinpad);

  @override
  List<Object> get props => [pinpad];
}

class TransLoadEmvTables extends TransactionEvent {
  final Pinpad pinpad;

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

class TransGoOnChip extends TransactionEvent {
  final Trans trans;

  const TransGoOnChip([this.trans]);

  @override
  List<Object> get props => [this.trans];
}

class TransShowMessage extends TransactionEvent {
  final String message;

  const TransShowMessage([this.message]);

  @override
  List<Object> get props => [this.message];
}

class TransCardWasRead extends TransactionEvent {
  final Map<String, dynamic> card;

  const TransCardWasRead([this.card]);

  @override
  List<Object> get props => [this.card];
}

class TransProcessCard extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransOnlineTransaction extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransProcessResponse extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransFinishChip extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransCardRemoved extends TransactionEvent {
  final Map<String, dynamic> finishData;

  TransCardRemoved([this.finishData]);

  @override
  List<Object> get props => [this.finishData];
}

class TransShowPinAmount extends TransactionEvent {
  @override
  List<Object> get props => [];
}
