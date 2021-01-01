import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/receipt.dart';
import 'package:pay/utils/reports.dart';

part 'totals_report_event.dart';
part 'totals_report_state.dart';

class TotalsReportBloc extends Bloc<TotalsReportEvent, TotalsReportState> {
  TotalsReportBloc() : super(TotalsReportInitial());

  @override
  Stream<TotalsReportState> mapEventToState(
    TotalsReportEvent event,
  ) async* {
    if (event is TotalsReportInitialEvent) {
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> totals = await transRepository.getTotalsData();
      List<Trans> listTrans = new List<Trans>();

      totals.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      yield TotalsReportDataReady(listTrans);
    } else if (event is TotalsReportPrintReceiptCopy) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      Receipt receipt = new Receipt(event.context);

      receipt.printTransactionReceiptCopy(event.type, trans);
    } else if (event is TotalsReportPrintReport) {
      Reports report = new Reports(event.context);
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      //report.printTotalReport(listTrans);
    }
  }
}
