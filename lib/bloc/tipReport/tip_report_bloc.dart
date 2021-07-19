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
          if (acquirer['id'] == element['acquirer'] && element['server'] != 0) {
            tipGrandTotal += element['total'];

            transPerAcquirer[acquirer['id']]['total'] += element['total'];
            transPerAcquirer[acquirer['id']]['tips'].add({'server': element['server'], 'count': element['count'], 'total': element['total']});
          }
        });
      });

      yield TipReportDataReady(transPerAcquirer, tipGrandTotal);
    } else if (event is TipReportPrintReport) {
      Reports report = new Reports();
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
          if (acquirer['id'] == element['acquirer']  && element['server'] != 0  ) {
            tipGrandTotal += element['total'];
            transPerAcquirer[acquirer['id']]['total'] += element['total'];
            transPerAcquirer[acquirer['id']]['tips'].add({'server': element['server'], 'count': element['count'], 'total': element['total']});
          }
        });
      });

      report.printTipReport(transPerAcquirer, tipGrandTotal);
    }
  }
}
