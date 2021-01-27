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

class TipAdjustPrintReport extends TipAdjustEvent {
  final BuildContext context;

  TipAdjustPrintReport(this.context);

  @override
  List<Object> get props => [context];
}

class TipAdjustViewTransDetail extends TipAdjustEvent {
  final int id;

  TipAdjustViewTransDetail(this.id);

  @override
  List<Object> get props => [id];
}
