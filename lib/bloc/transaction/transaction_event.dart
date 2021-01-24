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

class TransfinishTransaction extends TransactionEvent {
  @override
  List<Object> get props => [];
}
class TransInitPinpad extends TransactionEvent {
  final Pinpad pinpad;

  TransInitPinpad(this.pinpad);

  @override
  List<Object> get props => [pinpad];
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
  final Trans trans;

  TransProcessCard(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransGoOnChipDecision extends TransactionEvent {
  final Map<String, dynamic> chipDoneData;

  TransGoOnChipDecision(this.chipDoneData);

  @override
  List<Object> get props => [chipDoneData];
}

class TransOnlineTransaction extends TransactionEvent {
  final Trans trans;

  TransOnlineTransaction(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransProcessResponse extends TransactionEvent {
  final Map<int, String> respMap;

  TransProcessResponse(this.respMap);

  @override
  List<Object> get props => [respMap];
}

class TransFinishChip extends TransactionEvent {
  final Trans trans;

  TransFinishChip(this.trans);

  @override
  List<Object> get props => [trans];
}

class TransFinishChipComplete extends TransactionEvent {
  final Map<String, dynamic> finishData;

  TransFinishChipComplete([this.finishData]);

  @override
  List<Object> get props => [this.finishData];
}

class TransRemoveCard extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class RemovingCard extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransCardRemoved extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransShowPinAmount extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransCardError extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransAddLast4 extends TransactionEvent {
  final int last4;

  TransAddLast4(this.last4);

  @override
  List<Object> get props => [this.last4];
}

class TransLast4Back extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransAskIdNumber extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransAddIdNumber extends TransactionEvent {
  final int idNumber;

  TransAddIdNumber(this.idNumber);

  @override
  List<Object> get props => [this.idNumber];
}

class TransIDBack extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransAddCVV extends TransactionEvent {
  final int cvvNumber;

  TransAddCVV(this.cvvNumber);

  @override
  List<Object> get props => [this.cvvNumber];
}

class TransCVVBack extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransAddAccountType extends TransactionEvent {
  final int accType;

  TransAddAccountType(this.accType);

  @override
  List<Object> get props => [this.accType];
}

class TransConnect extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransSendReversal extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransReceiveReversal extends TransactionEvent {
  Trans transReversal;

  TransReceiveReversal(this.transReversal);

  @override
  List<Object> get props => [transReversal];
}

class TransSendRequest extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransReceive extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransPinEntered extends TransactionEvent {
  final Map<String, dynamic> pinData;

  TransPinEntered([this.pinData]);

  @override
  List<Object> get props => [this.pinData];
}

class TransMerchantReceipt extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransCustomerReceipt extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransVoidTransaction extends TransactionEvent {
  final int id;

  TransVoidTransaction(this.id);

  @override
  List<Object> get props => [id];
}

class TransAddServerNumber extends TransactionEvent {
  final int server;

  TransAddServerNumber(this.server);

  @override
  List<Object> get props => [server];
}

class TransServerBack extends TransactionEvent {
  @override
  List<Object> get props => [];
}