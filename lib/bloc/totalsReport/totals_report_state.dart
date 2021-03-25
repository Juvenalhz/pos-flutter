part of 'totals_report_bloc.dart';

abstract class TotalsReportState extends Equatable {
  const TotalsReportState();
}

class TotalsReportInitial extends TotalsReportState {
  @override
  List<Object> get props => [];
}

class TotalsReportDataReady extends TotalsReportState {
  final List<Map<String, dynamic>> totalsData;

  TotalsReportDataReady(this.totalsData);
  @override
  List<Object> get props => [totalsData];
}

class TotalsReportPrinting extends TotalsReportState {
  @override
  List<Object> get props => [];
}

class TotalsReportPrintOk extends TotalsReportState {
  final bool printFromBatch;

  TotalsReportPrintOk(this.printFromBatch);

  @override
  List<Object> get props => [printFromBatch];
}

class TotalsReportPrintError extends TotalsReportState {
  @override
  List<Object> get props => [];
}
