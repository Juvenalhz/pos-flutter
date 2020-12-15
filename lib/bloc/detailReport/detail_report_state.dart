part of 'detail_report_bloc.dart';

abstract class DetailReportState extends Equatable {
  const DetailReportState();
}

class DetailReportInitial extends DetailReportState {
  @override
  List<Object> get props => [];
}

class DetailReportDataReady extends DetailReportState {
  final List<Map<String, dynamic>> transList;

  DetailReportDataReady(this.transList);
  @override
  List<Object> get props => [transList];
}
