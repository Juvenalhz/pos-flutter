part of 'totals_report_bloc.dart';

abstract class TotalsReportEvent extends Equatable {
  const TotalsReportEvent();
}

class TotalsReportInitialEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintReport extends TotalsReportEvent {
  final bool printFromBatch;

  TotalsReportPrintReport(this.printFromBatch);

  @override
  List<Object> get props => [printFromBatch];
}

class TotalsReportOnPrintOKEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportOnPrintErrorEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintCancel extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintRetry extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}
