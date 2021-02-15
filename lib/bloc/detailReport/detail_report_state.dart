part of 'detail_report_bloc.dart';

abstract class DetailReportState extends Equatable {
  const DetailReportState();
}

class DetailReportInitial extends DetailReportState {
  @override
  List<Object> get props => [];
}

class DetailReportDataReady extends DetailReportState {
  final List<Trans> transList;

  DetailReportDataReady(this.transList);
  @override
  List<Object> get props => [transList];
}

class DetailReportShowTransDetail extends DetailReportState {
  final Trans trans;
  final String cardBrand;

  DetailReportShowTransDetail(this.trans, this.cardBrand);

  @override
  List<Object> get props => [trans, cardBrand];
}

class DetailReportPrinting extends DetailReportState {
  @override
  List<Object> get props => [];
}

class DetailReportPrintOk extends DetailReportState {
  @override
  List<Object> get props => [];
}

class DetailReportPrintError extends DetailReportState {
  @override
  List<Object> get props => [];
}
