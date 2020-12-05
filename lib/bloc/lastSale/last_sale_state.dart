part of 'last_sale_bloc.dart';

abstract class LastSaleState extends Equatable {
  const LastSaleState();
}

class LastSaleInitial extends LastSaleState {
  @override
  List<Object> get props => [];
}


class LastSaleConnecting extends LastSaleState {
  final Comm comm;

  LastSaleConnecting(this.comm);

  @override
  List<Object> get props => [comm];
}

class LastSaleSending extends LastSaleState {
  @override
  List<Object> get props => [];
}

class LastSaleReceiving extends LastSaleState {
  @override
  List<Object> get props => [];
}

class LastSaleCompleted extends LastSaleState {
  final Trans trans;

  LastSaleCompleted(this.trans);

  @override
  List<Object> get props => [trans];
}

class LastSaleFailed extends LastSaleState {
  final String message;

  LastSaleFailed(this.message);

  @override
  List<Object> get props => [message];
}

class LastSaleCommError extends LastSaleState {
  @override
  List<Object> get props => [];
}

class LastSaleShowMessage extends LastSaleState {
  final String message;

  LastSaleShowMessage(this.message);

  @override
  List<Object> get props => [message];
}
