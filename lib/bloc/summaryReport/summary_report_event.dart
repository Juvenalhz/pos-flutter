part of 'summary_report_bloc.dart';

abstract class SummaryReportEvent extends Equatable {
  const SummaryReportEvent();
}

class SummaryReportInitialEvent extends SummaryReportEvent {
  @override
  List<Object> get props => [];
}

class SummaryReportPrintReport extends SummaryReportEvent {
  final BuildContext context;

  SummaryReportPrintReport(this.context);

  @override
  List<Object> get props => [context];
}
