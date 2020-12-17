import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/trans_repository.dart';

part 'detail_report_event.dart';
part 'detail_report_state.dart';

class DetailReportBloc extends Bloc<DetailReportEvent, DetailReportState> {
  DetailReportBloc() : super(DetailReportInitial());

  @override
  Stream<DetailReportState> mapEventToState(
    DetailReportEvent event,
  ) async* {
    if (event is DetailReportInitialEvent) {
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0');
      yield DetailReportDataReady(transList);
    }
  }
}
