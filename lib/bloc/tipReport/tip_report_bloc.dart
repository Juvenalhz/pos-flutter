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

part 'tip_report_event.dart';
part 'tip_report_state.dart';

class TipReportBloc extends Bloc<TipReportEvent, TipReportState> {
  TipReportBloc() : super(TipReportInitial());

  @override
  Stream<TipReportState> mapEventToState(
    TipReportEvent event,
  ) async* {
    if (event is TipReportInitialEvent) {
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0 and binType = 1');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      yield TipReportDataReady(listTrans);
    } else if (event is TipReportPrintReceiptCopy) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      Receipt receipt = new Receipt(event.context);

      receipt.printTransactionReceiptCopy(event.type, trans);
    } else if (event is TipReportPrintReport) {
      Reports report = new Reports(event.context);
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      report.printTipReport(listTrans);
    } else if (event is TipReportViewTransDetail) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      BinRepository binRepository = new BinRepository();
      Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));

      if (trans.respMessage == null) trans.respMessage = '';
      yield TipReportShowTransDetail(trans, bin.brand);
    }
  }
}
