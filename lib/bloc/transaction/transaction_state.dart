part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddAmount extends TransactionState {
  final Trans trans;

  TransactionAddAmount(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionAddTip extends TransactionState {
  final Trans trans;

  TransactionAddTip(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionAskConfirmation extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoadEmvTable extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionWaitEmvTablesLoaded extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionGetCard extends TransactionState {
  final Trans trans;

  TransactionGetCard(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionShowMessage extends TransactionState {
  final String message;

  TransactionShowMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionCardRead extends TransactionState {
  final Trans trans;

  TransactionCardRead(this.trans);

  @override
  List<Object> get props => [trans];
}
