import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/repository/acquirer_repository.dart';
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
      AcquirerRepository acquirerRepository = new AcquirerRepository();
      TransRepository transRepository = new TransRepository();
      //Trans trans = Trans.fromMap(await transRepository.getTrans(1));

      // var rng = new Random();
      // for (int i = 0; i < 299; i++) {
      //   int r = rng.nextInt(8);
      //   int r2 = rng.nextInt(3);
      //   int r3 = rng.nextInt(3);
      //
      //   trans.baseAmount = 100;
      //   trans.total = 100;
      //   trans.acquirer = r3;
      //   trans.id = (await transRepository.getMaxId()) + 1;
      //
      //   if (r == 0) {
      //     trans.bin = 7;
      //   } else if (r == 1) {
      //     trans.bin = 50;
      //   } else if (r == 2) {
      //     trans.bin = 42;
      //   } else if (r == 3) {
      //     trans.bin = 76;
      //   } else if (r == 4) {
      //     trans.bin = 71;
      //   } else if (r == 5) {
      //     trans.bin = 72;
      //   } else if (r == 6) {
      //     trans.bin = 1;
      //   } else if (r == 7) {
      //     trans.bin = 20;
      //   }
      //
      //   if (r2 == 0) {
      //     trans.issuer = '';
      //   } else if (r2 == 1) {
      //     trans.issuer = '0108';
      //   } else if (r2 == 2) {
      //     trans.issuer = '0105';
      //   }
      //   await transRepository.createTrans(trans);
      // }

      List<Map<String, dynamic>> totals = await transRepository.getTotalsData();
      List<Map<String, dynamic>> totalsData = new List<Map<String, dynamic>>();

      List<Trans> listTrans = new List<Trans>();
      int index;

      totals.forEach((element) {
        print(element.toString());
        if (totalsData.firstWhere((item) => item['acquirer'] == element['acquirer'], orElse: () => null) == null) {

          List<String> fields = ['visaCount', 'visaAmount', 'mastercardCount', 'mastercardAmount', 'dinersCount', 'dinersAmount',
            'debitCount', 'debitAmount', 'electronCount', 'electronAmount', 'privateCount', 'privateAmount', 'foodCount', 'foodAmount',
            'visaOtherCount', 'visaOtherAmount', 'mastercardOtherCount', 'mastercardOtherAmount', 'dinersOtherCount', 'dinersOtherAmount',
            'debitOtherCount', 'debitOtherAmount',  'electronOtherCount', 'electronOtherAmount', 'privateOtherCount', 'privateOtherAmount',
            'foodOtherCount', 'foodOtherAmount',  ];
          List<int> emptyValues = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
          Map<String, dynamic> emptyRecord = Map.fromIterables(fields, emptyValues);

          totalsData.add({'acquirer': element['acquirer'], 'totals': emptyRecord});
          if (index == null)
            index = 0;
          else
            index ++;
        }

        if (element['acquirer'] == 'Platco'){
          if (element['issuer'].length == 0){
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaCount'] = element['count'];
              totalsData[index]['totals']['visaAmount'] = element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronCount'] = element['count'];
              totalsData[index]['totals']['electronAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardCount'] = element['count'];
              totalsData[index]['totals']['mastercardAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersCount'] = element['count'];
              totalsData[index]['totals']['dinersAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitCount'] = element['count'];
              totalsData[index]['totals']['debitAmount'] = element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateCount'] = element['count'];
              totalsData[index]['totals']['privateAmount'] = element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodCount'] = element['count'];
              totalsData[index]['totals']['foodAmount'] = element['total'];
            }
          }
          else {
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaOtherCount'] += element['count'];
              totalsData[index]['totals']['visaOtherAmount'] += element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronOtherCount'] += element['count'];
              totalsData[index]['totals']['electronOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardOtherCount'] += element['count'];
              totalsData[index]['totals']['mastercardOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersOtherCount'] += element['count'];
              totalsData[index]['totals']['dinersOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitOtherCount'] += element['count'];
              totalsData[index]['totals']['debitOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateOtherCount'] += element['count'];
              totalsData[index]['totals']['privateOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodOtherCount'] += element['count'];
              totalsData[index]['totals']['foodOtherAmount'] += element['total'];
            }
          }
        } else if (element['acquirer'].toLowerCase().contains('mercantil')){
          if (element['issuer'] == '0105'){
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaCount'] = element['count'];
              totalsData[index]['totals']['visaAmount'] = element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronCount'] = element['count'];
              totalsData[index]['totals']['electronAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardCount'] = element['count'];
              totalsData[index]['totals']['mastercardAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersCount'] = element['count'];
              totalsData[index]['totals']['dinersAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitCount'] = element['count'];
              totalsData[index]['totals']['debitAmount'] = element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateCount'] = element['count'];
              totalsData[index]['totals']['privateAmount'] = element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodCount'] = element['count'];
              totalsData[index]['totals']['foodAmount'] = element['total'];
            }
          }
          else {
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaOtherCount'] += element['count'];
              totalsData[index]['totals']['visaOtherAmount'] += element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronOtherCount'] += element['count'];
              totalsData[index]['totals']['electronOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardOtherCount'] += element['count'];
              totalsData[index]['totals']['mastercardOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersOtherCount'] += element['count'];
              totalsData[index]['totals']['dinersOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitOtherCount'] += element['count'];
              totalsData[index]['totals']['debitOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateOtherCount'] += element['count'];
              totalsData[index]['totals']['privateOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodOtherCount'] += element['count'];
              totalsData[index]['totals']['foodOtherAmount'] += element['total'];
            }
          }
        }else if (element['acquirer'].toLowerCase().contains('provincial')){
          if (element['issuer'] == '0108'){
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaCount'] = element['count'];
              totalsData[index]['totals']['visaAmount'] = element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronCount'] = element['count'];
              totalsData[index]['totals']['electronAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardCount'] = element['count'];
              totalsData[index]['totals']['mastercardAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersCount'] = element['count'];
              totalsData[index]['totals']['dinersAmount'] = element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitCount'] = element['count'];
              totalsData[index]['totals']['debitAmount'] = element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateCount'] = element['count'];
              totalsData[index]['totals']['privateAmount'] = element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodCount'] = element['count'];
              totalsData[index]['totals']['foodAmount'] = element['total'];
            }
          }
          else {
            if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 1)){  // visa credit card
              totalsData[index]['totals']['visaOtherCount'] += element['count'];
              totalsData[index]['totals']['visaOtherAmount'] += element['total'];
            }
            else if ((element['brand'].toLowerCase().contains('visa')) && (element['cardType'] == 2)) { // visa debit card
              totalsData[index]['totals']['electronOtherCount'] += element['count'];
              totalsData[index]['totals']['electronOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('mastercard')) { // master card
              totalsData[index]['totals']['mastercardOtherCount'] += element['count'];
              totalsData[index]['totals']['mastercardOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('diners')) { // diners card
              totalsData[index]['totals']['dinersOtherCount'] += element['count'];
              totalsData[index]['totals']['dinersOtherAmount'] += element['total'];
            }
            else if (element['brand'].toLowerCase().contains('maestro')) { // maestro debit card
              totalsData[index]['totals']['debitOtherCount'] += element['count'];
              totalsData[index]['totals']['debitOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 4) { // master card
              totalsData[index]['totals']['privateOtherCount'] += element['count'];
              totalsData[index]['totals']['privateOtherAmount'] += element['total'];
            }
            else if (element['cardType'] == 3) { // master card
              totalsData[index]['totals']['foodOtherCount'] += element['count'];
              totalsData[index]['totals']['foodOtherAmount'] += element['total'];
            }
          }
        }
      });

      if (totalsData[0].isNotEmpty)
        print(totalsData[0].toString());
      if (totalsData[1].isNotEmpty)
        print(totalsData[1].toString());
      if (totalsData[2].isNotEmpty)
        print(totalsData[2].toString());

      yield TotalsReportDataReady(totalsData);
    } else if (event is TotalsReportPrintReport) {
      Reports report = new Reports(event.context);

      report.printTotalsReport(event.totalsData);
    }
  }
}
