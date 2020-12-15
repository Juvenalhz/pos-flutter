part of 'detail_report_bloc.dart';

abstract class DetailReportEvent extends Equatable {
  const DetailReportEvent();
}

class DetailReportInitialEvent extends DetailReportEvent {
  @override
  List<Object> get props => [];
}
