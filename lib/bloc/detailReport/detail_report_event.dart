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
