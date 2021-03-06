part of 'transaction_bloc.dart';

abstract class TransactionState {
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
  final Acquirer acquierer;

  TransactionAskConfirmation(this.trans, this.acquierer);

  @override
  List<Object> get props => [trans, acquierer];
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

class TransactionShowEntryCard extends TransactionState {
  final String message;

  TransactionShowEntryCard(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionCardRead extends TransactionState {
  final Trans trans;

  TransactionCardRead(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionOnChipDone extends TransactionState {
  final Trans trans;

  TransactionOnChipDone(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionProcessCard extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionOnlineTransaction extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionProcessResponse extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionCompleted extends TransactionState {
  final Trans trans;
  final Terminal terminal;

  TransactionCompleted(this.trans, this.terminal);

  @override
  List<Object> get props => [trans, terminal];
}

class TransactionShowPinAmount extends TransactionState {
  final Trans trans;
  TransactionShowPinAmount(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionError extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskIdNumber extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskLast4Digits extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskCVV extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskAccountType extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionConnecting extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionSending extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionReceiving extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionRejected extends TransactionState {
  final Trans trans;
  TransactionRejected(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionPrintMerchantReceipt extends TransactionState {
  final Trans trans;
  TransactionPrintMerchantReceipt(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionPrintCustomerReceipt extends TransactionState {
  final Trans trans;
  TransactionPrintCustomerReceipt(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionFinish extends TransactionState {
  final Trans trans;

  TransactionFinish(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransactionCommError extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskPrintCustomer extends TransactionState {
  final Trans trans;
  final Acquirer acquierer;

  TransactionAskPrintCustomer(this.trans, this.acquierer);
  @override
  List<Object> get props => [trans];
}

class TransactionDigitalReceiptCustomer extends TransactionState {
  final Trans trans;
  final Acquirer acquierer;
  final Merchant merchant;
  final Terminal terminal;

  TransactionDigitalReceiptCustomer(this.trans, this.acquierer, this.merchant, this.terminal);
  @override
  List<Object> get props => [trans, acquierer, merchant, terminal];
}

class TransactionAskServerNumber extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionPrintMerchantError extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionPrintCustomerError extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAutoCloseBatch extends TransactionState{
  final int batchNumber;

  TransactionAutoCloseBatch(this.batchNumber);

  @override
  List<Object> get props => [batchNumber];
}

class TransactionAskAccountNumber extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAskExpDate extends TransactionState {
  @override
  List<Object> get props => [];
}