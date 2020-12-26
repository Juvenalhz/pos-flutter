part of 'totals_report_bloc.dart';

abstract class TotalsReportState extends Equatable {
  const TotalsReportState();
}

class TotalsReportInitial extends TotalsReportState {
  @override
  List<Object> get props => [];
}

class TotalsReportDataReady extends TotalsReportState {
  final List<Trans> transList;

  TotalsReportDataReady(this.transList);
  @override
  List<Object> get props => [transList];
}


