part of 'totals_report_bloc.dart';

abstract class TotalsReportEvent extends Equatable {
  const TotalsReportEvent();
}

class TotalsReportInitialEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintReport extends TotalsReportEvent {
  final BuildContext context;
  final bool printFromBatch;

  TotalsReportPrintReport(this.context, {this.printFromBatch});

  @override
  List<Object> get props => [context, printFromBatch];
}

class TotalsReportOnPrintOKEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}

class TotalsReportOnPrintErrorEvent extends TotalsReportEvent {
  @override
  List<Object> get props => [];
}
