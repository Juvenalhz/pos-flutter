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
  final BuildContext context;

  DetailReportPrintReport(this.context);

  @override
  List<Object> get props => [context];
}

class DetailReportViewTransDetail extends DetailReportEvent {
  final int id;

  DetailReportViewTransDetail(this.id);

  @override
  List<Object> get props => [id];
}
