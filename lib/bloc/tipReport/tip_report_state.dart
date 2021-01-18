part of 'tip_report_bloc.dart';

abstract class TipReportState extends Equatable {
  const TipReportState();
}

class TipReportInitial extends TipReportState {
  @override
  List<Object> get props => [];
}

class TipReportDataReady extends TipReportState {
  final List<Trans> transList;

  TipReportDataReady(this.transList);
  @override
  List<Object> get props => [transList];
}

class TipReportShowTransDetail extends TipReportState {
  final Trans trans;
  final String cardBrand;

  TipReportShowTransDetail(this.trans, this.cardBrand);

  @override
  List<Object> get props => [trans, cardBrand];
}
