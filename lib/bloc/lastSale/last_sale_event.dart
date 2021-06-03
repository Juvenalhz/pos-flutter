part of 'last_sale_bloc.dart';

abstract class LastSaleEvent extends Equatable {
  const LastSaleEvent();
}

class LastSaleInitialEvent extends LastSaleEvent {
  @override
  List<Object> get props => [];
}

class LastSaleConnect extends LastSaleEvent {
  final Comm comm;

  LastSaleConnect(this.comm);

  @override
  List<Object> get props => [this.comm];
}

class LastSaleSend extends LastSaleEvent {
  @override
  List<Object> get props => [];
}

class LastSaleReceive extends LastSaleEvent {
  @override
  List<Object> get props => [];
}

class LastSaleProcess extends LastSaleEvent {
  @override
  List<Object> get props => [];
}

