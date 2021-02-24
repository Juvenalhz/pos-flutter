import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/receipt.dart';
import 'package:pay/utils/reports.dart';

part 'detail_report_event.dart';
part 'detail_report_state.dart';

class DetailReportBloc extends Bloc<DetailReportEvent, DetailReportState> {
  bool printFromBatch;

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
      Receipt receipt = new Receipt();

      receipt.printTransactionReceipt(event.type, trans, onPrintOK, onPrintError);
    } else if (event is DetailReportPrintReport) {
      Reports report = new Reports();
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      if (event.printFromBatch != null) {
        printFromBatch = event.printFromBatch;
      }

      if ((event.printFromBatch != null) && (event.printFromBatch == true)) {
        yield DetailReportPrinting();
      }
      report.printDetailReport(listTrans, onPrintOK, onPrintError);
    } else if (event is DetailReportViewTransDetail) {
      TransRepository transRepository = new TransRepository();
      Trans trans = Trans.fromMap(await transRepository.getTrans(event.id));
      BinRepository binRepository = new BinRepository();
      Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));

      if (trans.respMessage == null) trans.respMessage = '';
      yield DetailReportShowTransDetail(trans, bin.brand);
    } else if (event is DetailReportOnPrintOKEvent) {
      if (printFromBatch)
        yield DetailReportPrintOk(printFromBatch);
      else
        this.add(DetailReportInitialEvent());
    } else if (event is DetailReportOnPrintErrorEvent) {
      yield DetailReportPrintError();
    } else if (event is DetailReportPrintRetry) {
      this.add(DetailReportPrintReport(printFromBatch));
    } else if (event is DetailReportPrintCancel) {
      this.add(DetailReportOnPrintOKEvent());
    } else if (event is DetailReportVoidPassword) {
      yield DetailReportVoidCheckPassword(event.id, event.terminal);
    }
  }

  void onPrintOK() {
    this.add(DetailReportOnPrintOKEvent());
  }

  void onPrintError(int type) {
    this.add(DetailReportOnPrintErrorEvent());
  }
}
