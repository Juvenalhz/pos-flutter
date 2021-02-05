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
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      yield DetailReportDataReady(listTrans);
    } else if (event is DetailReportPrintReceiptCopy) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      Receipt receipt = new Receipt(event.context);

      receipt.printTransactionReceipt(event.type, trans);
    } else if (event is DetailReportPrintReport) {
      Reports report = new Reports(event.context);
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      report.printDetailReport(listTrans);
    } else if (event is DetailReportViewTransDetail) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      BinRepository binRepository = new BinRepository();
      Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));

      if (trans.respMessage == null) trans.respMessage = '';
      yield DetailReportShowTransDetail(trans, bin.brand);
    }
  }
}
