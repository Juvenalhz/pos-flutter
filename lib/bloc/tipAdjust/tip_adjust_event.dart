part of 'tip_adjust_bloc.dart';

abstract class TipAdjustEvent extends Equatable {
  const TipAdjustEvent();
}

class TipAdjustInitialEvent extends TipAdjustEvent {
  @override
  List<Object> get props => [];
}

class TipAdjustPrintReceiptCopy extends TipAdjustEvent {
  final int id;
  final bool type;
  final BuildContext context;

  TipAdjustPrintReceiptCopy(this.type, this.id, this.context);

  @override
  List<Object> get props => [type, id];
}

class TipAdjustAskTip extends TipAdjustEvent {
  final Trans trans;

  TipAdjustAskTip(this.trans);

  @override
  List<Object> get props => [trans];
}

class TipAdjustAddTip extends TipAdjustEvent {
  final int tip;

  TipAdjustAddTip(this.tip);

  @override
  List<Object> get props => [tip];
}
