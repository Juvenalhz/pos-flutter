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
  final bool printFromBatch;

  DetailReportPrintOk(this.printFromBatch);

  @override
  List<Object> get props => [printFromBatch];
}

class DetailReportPrintError extends DetailReportState {
  @override
  List<Object> get props => [];
}

class DetailReportVoidCheckPassword extends DetailReportState {
  final int id;
  final Terminal terminal;

  DetailReportVoidCheckPassword(this.id, this.terminal);

  @override
  List<Object> get props => [id, terminal];
}
