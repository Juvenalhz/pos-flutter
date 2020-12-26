part of 'totals_report_bloc.dart';

abstract class TotalsReportEvent extends Equatable {
  const TotalsReportEvent();
}

class TotalsReportInitialEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintReceiptCopy extends TotalsReportEvent {
  final int id;
  final bool type;
  final BuildContext context;

  TotalsReportPrintReceiptCopy(this.type, this.id, this.context);

  @override
  List<Object> get props => [type, id];
}

class TotalsReportPrintReport extends TotalsReportEvent {
  final BuildContext context;

  TotalsReportPrintReport(this.context);

  @override
  List<Object> get props => [context];
}

