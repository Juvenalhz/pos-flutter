part of 'summary_report_bloc.dart';

abstract class SummaryReportState extends Equatable {
  const SummaryReportState();
}

class SummaryReportInitial extends SummaryReportState {
  @override
  List<Object> get props => [];
}

class SummaryReportDataReady extends SummaryReportState {
  final Merchant merchant;
  final Terminal terminal;
  final Comm comm;
  final Acquirer acquirer;

  SummaryReportDataReady(this.merchant, this.terminal, this.comm, this.acquirer);

  @override
  List<Object> get props => [merchant, terminal, comm, acquirer];
}
