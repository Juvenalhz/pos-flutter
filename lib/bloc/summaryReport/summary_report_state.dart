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
  final Emv emv;

  SummaryReportDataReady(this.merchant, this.terminal, this.comm, this.acquirer,this.emv);

  @override
  List<Object> get props => [merchant, terminal, comm, acquirer, emv];
}
