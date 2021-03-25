part of 'tip_report_bloc.dart';

abstract class TipReportEvent extends Equatable {
  const TipReportEvent();
}

class TipReportInitialEvent extends TipReportEvent {
  @override
  List<Object> get props => [];
}

class TipReportPrintReceiptCopy extends TipReportEvent {
  final int id;
  final bool type;
  final BuildContext context;

  TipReportPrintReceiptCopy(this.type, this.id, this.context);

  @override
  List<Object> get props => [type, id];
}

class TipReportPrintReport extends TipReportEvent {
  final BuildContext context;

  TipReportPrintReport(this.context);

  @override
  List<Object> get props => [context];
}

class TipReportViewTransDetail extends TipReportEvent {
  final int id;

  TipReportViewTransDetail(this.id);

  @override
  List<Object> get props => [id];
}
