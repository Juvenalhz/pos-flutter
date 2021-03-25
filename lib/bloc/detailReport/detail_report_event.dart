part of 'detail_report_bloc.dart';

abstract class DetailReportEvent extends Equatable {
  const DetailReportEvent();
}

class DetailReportInitialEvent extends DetailReportEvent {
  @override
  List<Object> get props => [];
}

class DetailReportPrintReceiptCopy extends DetailReportEvent {
  final int id;
  final bool type;
  final BuildContext context;

  DetailReportPrintReceiptCopy(this.type, this.id, this.context);

  @override
  List<Object> get props => [type, id];
}

class DetailReportPrintReport extends DetailReportEvent {
  final bool printFromBatch;

  DetailReportPrintReport(this.printFromBatch);

  @override
  List<Object> get props => [printFromBatch];
}

class DetailReportViewTransDetail extends DetailReportEvent {
  final int id;

  DetailReportViewTransDetail(this.id);

  @override
  List<Object> get props => [id];
}

class DetailReportOnPrintOKEvent extends DetailReportEvent {
  @override
  List<Object> get props => [];
}

class DetailReportOnPrintErrorEvent extends DetailReportEvent {
  @override
  List<Object> get props => [];
}

class DetailReportPrintCancel extends DetailReportEvent {
  @override
  List<Object> get props => [];
}

class DetailReportPrintRetry extends DetailReportEvent {
  @override
  List<Object> get props => [];
}

class DetailReportVoidPassword extends DetailReportEvent {
  final int id;
  final Terminal terminal;

  DetailReportVoidPassword(this.id, this.terminal);

  @override
  List<Object> get props => [id, terminal];
}
