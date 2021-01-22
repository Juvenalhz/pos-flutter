import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
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
      AcquirerRepository acquirerRepository = new AcquirerRepository();
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> acquirers = await acquirerRepository.getAllacquirers();
      List<Map<String, dynamic>> tipsList = await transRepository.getTipsByServer();
      List<Map<String, dynamic>> transPerAcquirer = new List<Map<String, dynamic>>();
      int tipGrandTotal = 0;

      acquirers.forEach((acquirer) {
        if (transPerAcquirer.firstWhere((item) => item['acquirer'] == acquirer['id'], orElse: () => null) == null) {
          transPerAcquirer
              .add({'id': acquirer['id'], 'acquirer': acquirer['name'].toString().trim(), 'total': 0, 'tips': new List<Map<String, dynamic>>()});
        }

        tipsList.forEach((element) {
          if (acquirer['id'] == element['acquirer']) {
            tipGrandTotal += element['total'];
            ;
            transPerAcquirer[acquirer['id']]['total'] += element['total'];
            transPerAcquirer[acquirer['id']]['tips'].add({'server': element['server'], 'count': element['count'], 'total': element['total']});
          }
        });
      });

      yield TipReportDataReady(transPerAcquirer, tipGrandTotal);
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
