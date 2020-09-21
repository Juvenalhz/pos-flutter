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
  final Trans trans;

  TransactionAskConfirmation(this.trans);

  @override
  List<Object> get props => [trans];
}
