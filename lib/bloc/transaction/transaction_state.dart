part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddAmount extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddTip extends TransactionState {
  Trans trans;

  TransactionAddTip(this.trans);
  @override
  List<Object> get props => [trans];
}

class TransactionAskConfirmation extends TransactionState {
  @override
  List<Object> get props => [];
}
