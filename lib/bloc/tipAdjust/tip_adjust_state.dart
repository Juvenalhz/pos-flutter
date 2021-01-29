part of 'tip_adjust_bloc.dart';

abstract class TipAdjustState extends Equatable {
  const TipAdjustState();
}

class TipAdjustInitial extends TipAdjustState {
  @override
  List<Object> get props => [];
}

class TipAdjustDataReady extends TipAdjustState {
  final List<Trans> transList;

  TipAdjustDataReady(this.transList);
  @override
  List<Object> get props => [transList];
}

class TipAdjustShowTransDetail extends TipAdjustState {
  final Trans trans;
  final String cardBrand;

  TipAdjustShowTransDetail(this.trans, this.cardBrand);

  @override
  List<Object> get props => [trans, cardBrand];
}

class TipAdjustPromptTip extends TipAdjustState {
  final Trans trans;

  TipAdjustPromptTip(this.trans);

  @override
  List<Object> get props => [trans];
}

class TipAdjustShowMessage extends TipAdjustState {
  final Trans trans;
  final String message;

  TipAdjustShowMessage(this.trans, this.message);

  @override
  List<Object> get props => [trans, message];
}
