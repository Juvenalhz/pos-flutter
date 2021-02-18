import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/constants.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/utils/serialNumber.dart';

class Reports {
  void _addHeader(Printer printer) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));

    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, merchant.nameL1);
    printer.addText(Printer.CENTER, merchant.nameL2);
    printer.addText(Printer.CENTER, merchant.city);
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addTextSideBySide('RIF:' + merchant.taxID, 'Afiliado:' + merchant.mid.trim());
  }

  void _addTerminalData(Printer printer) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime now = DateTime.now();
    String tid = merchant.tid;
    String batch = merchant.batchNumber.toString().trim();
    String sn = (await SerialNumber.serialNumber).padLeft(20, ' ');

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addTextSideBySide('Fecha:' + DateFormat('dd/MM/yyyy').format(now), 'Hora:' + DateFormat('hh:mm:ss a').format(now));
    printer.addTextSideBySideWithCenter('Terminal', 'Lote', 'S/N POS');
    printer.addTextSideBySideWithCenter(merchant.tid.padLeft(5, ' '), merchant.batchNumber.toString(), await SerialNumber.serialNumber);
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
  }

  void printDetailReport(List<Trans> transList, Function onPrintOk, Function onPrintError) async {
    Printer printer = new Printer();
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
    TransRepository transRepository = new TransRepository();

    await _addHeader(printer);
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, 'REPORTE DETALLADO');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    await _addTerminalData(printer);

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.LEFT, 'Ticket      Nro. Tarjeta               Bs.');
    printer.addText(Printer.LEFT, 'Tipo                     Fecha           Hora');
    printer.addTextFillLine('-');

    transList.forEach((element) {
      String ticket = element.id.toString().padLeft(3, ' ');
      String acct = element.maskedPAN;
      String amount = formatter.format(element.total / 100).padLeft(15, ' ');
      String type = element.type.padRight(15, ' ');
      String date = DateFormat('dd/MM/yyyy').format(element.dateTime);
      String hour = DateFormat('hh:mm:ss').format(element.dateTime);

      printer.addText(Printer.LEFT, '$ticket        $acct            $amount');
      printer.addText(Printer.LEFT, '$type          $date     $hour');
    });

    printer.addText(Printer.LEFT, 'Totales');
    printer.addTextSideBySide('Cantidad de Transacciones:', (await transRepository.getCountTrans()).toString());
    printer.addTextSideBySide('Bs.:', formatter.format(await transRepository.getBatchTotal() / 100).toString().trim());
    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);

    printer.feedLine(5);

    printer.print(onPrintOk, onPrintError);
  }

  void printTotalsReport(List<Map<String, dynamic>> totalsData, Function onPrintOk, Function onPrintError) async {
    Printer printer = new Printer();
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
    await _addHeader(printer);
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, 'REPORTE DE TOTALES');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    await _addTerminalData(printer);

    totalsData.forEach((element) {
      Map<String, dynamic> totals = element['totals'];
      String acquirer;
      String acquirerShort;

      int countTDCOwn = totals['visaCount'] + totals['mastercardCount'] + totals['dinersCount'] + totals['privateCount'];
      int totalTDCOwn = totals['visaAmount'] + totals['mastercardAmount'] + totals['dinersAmount'] + totals['privateAmount'];
      int countTDCOther = totals['visaOtherCount'] + totals['mastercardOtherCount'] + totals['dinersOtherCount'] + totals['privateOtherCount'];
      int totalTDCOther = totals['visaOtherAmount'] + totals['mastercardOtherAmount'] + totals['dinersOtherAmount'] + totals['privateOtherAmount'];

      int countTDD = totals['debitCount'] + totals['debitOtherCount'];
      int totalTDD = totals['debitAmount'] + totals['debitOtherAmount'];
      int countTDDElectron = totals['electronCount'] + totals['electronOtherCount'];
      int totalTDDElectron = totals['electronAmount'] + totals['electronOtherAmount'];

      int totalTCD_TDD = totalTDCOwn + totalTDCOther + totalTDD + totalTDDElectron;

      if (element['acquirer'].toLowerCase().contains('platco')) {
        acquirer = 'Platco';
        acquirerShort = 'PL';
      } else if (element['acquirer'].toLowerCase().contains('mercantil')) {
        acquirer = 'Mercantil';
        acquirerShort = 'BM';
      } else if (element['acquirer'].toLowerCase().contains('provincial')) {
        acquirer = 'Provincial';
        acquirerShort = 'BP';
      }

      printer.setFontSize(Printer.FONT_SIZE_NORMAL);
      printer.addText(Printer.LEFT, 'ADQUIRIENCIA: ' + element['acquirer']);
      printer.addText(Printer.CENTER, 'TDC');
      printer.setFontSize(Printer.FONT_SIZE_SMALL);

      printer.addTextSideBySide(
          totals['visaCount'].toString().padLeft(4, '0') + '  VISA ' + acquirerShort, formatter.format(totals['visaAmount'] / 100));
      printer.addTextSideBySide(
          totals['mastercardCount'].toString().padLeft(4, '0') + '  MASTER ' + acquirerShort, formatter.format(totals['mastercardAmount'] / 100));
      printer.addTextSideBySide(
          totals['dinersCount'].toString().padLeft(4, '0') + '  DINERS ' + acquirerShort, formatter.format(totals['dinersAmount'] / 100));
      printer.addTextSideBySide(
          totals['privateCount'].toString().padLeft(4, '0') + '  Tarj. PRIV ' + acquirerShort, formatter.format(totals['privateAmount'] / 100));
      printer.addTextSideBySide(countTDCOwn.toString().padLeft(4, '0') + '  Total TDC ' + acquirerShort, formatter.format(totalTDCOwn / 100));

      printer.setFontSize(Printer.FONT_SIZE_NORMAL);
      printer.addText(Printer.CENTER, 'TDC OTROS BANCOS');
      printer.setFontSize(Printer.FONT_SIZE_SMALL);

      printer.addTextSideBySide(
          totals['visaOtherCount'].toString().padLeft(4, '0') + '  VISA o/Ban', formatter.format(totals['visaOtherAmount'] / 100));
      printer.addTextSideBySide(
          totals['mastercardOtherCount'].toString().padLeft(4, '0') + '  MASTER  o/Ban', formatter.format(totals['mastercardOtherAmount'] / 100));
      if (totals['dinersOtherCount'] != 0)
        printer.addTextSideBySide(
            totals['dinersOtherCount'].toString().padLeft(4, '0') + '  DINERS  o/Ban', formatter.format(totals['dinersOtherAmount'] / 100));
      if (totals['privateOtherCount'] != 0)
        printer.addTextSideBySide(
            totals['privateOtherCount'].toString().padLeft(4, '0') + '  Tarj. PRIV  o/Ban', formatter.format(totals['privateOtherAmount'] / 100));
      printer.addTextSideBySide(countTDCOther.toString().padLeft(4, '0') + '  Total TDC o/Ban', formatter.format(totalTDCOther / 100));
      printer.addTextSideBySide('Total TDC', formatter.format((totalTDCOwn + totalTDCOther) / 100));

      printer.setFontSize(Printer.FONT_SIZE_NORMAL);
      printer.addText(Printer.CENTER, 'TDD');
      printer.setFontSize(Printer.FONT_SIZE_SMALL);

      printer.addTextSideBySide(
          totals['debitCount'].toString().padLeft(4, '0') + '  Total TDD ' + acquirerShort, formatter.format(totals['debitAmount'] / 100));
      printer.addTextSideBySide(
          totals['debitOtherCount'].toString().padLeft(4, '0') + '  Total TDD o/Ban', formatter.format(totals['debitOtherAmount'] / 100));

      printer.setFontSize(Printer.FONT_SIZE_NORMAL);
      printer.addText(Printer.CENTER, 'TDD VISA ELECTRON');
      printer.setFontSize(Printer.FONT_SIZE_SMALL);

      printer.addTextSideBySide(
          totals['electronCount'].toString().padLeft(4, '0') + '  Total TVE ' + acquirerShort, formatter.format(totals['electronAmount'] / 100));
      printer.addTextSideBySide(
          totals['electronOtherCount'].toString().padLeft(4, '0') + '  Total TVE o/Ban', formatter.format(totals['electronOtherAmount'] / 100));
      printer.addTextSideBySide('Total TDD', formatter.format((totalTDD + totalTDDElectron) / 100));

      printer.setFontSize(Printer.FONT_SIZE_NORMAL);
      printer.addText(Printer.CENTER, 'ALIMENTACIÓN');
      printer.setFontSize(Printer.FONT_SIZE_SMALL);

      printer.addTextSideBySide(totals['foodCount'].toString().padLeft(4, '0') + '  Total TAE ', formatter.format(totals['foodAmount'] / 100));

      printer.addTextSideBySide('Total TDC+TDD', formatter.format(totalTCD_TDD / 100));
      printer.addTextSideBySide('Total Cestaticket', formatter.format(totals['foodAmount'] / 100));
    });

    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(5);

    printer.print(onPrintOk, onPrintError);
  }

  printTipReport(List<Map<String, dynamic>> transList, int tipGrandTotal) async {
    Printer printer = new Printer();
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    await _addHeader(printer);
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, 'RESUMEN DE PROPINAS');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    await _addTerminalData(printer);

    transList.forEach((element) {
      List<Map<String, dynamic>> tips = element['tips'];

      printer.feedLine(1);
      printer.addText(Printer.CENTER, 'ADQUIRIENCIA: ' + element['acquirer'].trim());
      printer.addTextSideBySide(' Num   Mesero', 'Propina');

      tips.forEach((i) {
        printer.addTextSideBySide(i['count'].toString().padLeft(3, ' ') + i['server'].toString().padLeft(8, ' '),
            formatter.format(i['total'] / 100).padLeft(15, ' ').trim());
      });

      printer.addTextSideBySide('Total Propinas:', formatter.format(element['total'] / 100).padLeft(15, ' ').trim());
    });
    printer.addTextSideBySide('T.Gral Propinas:', formatter.format(tipGrandTotal / 100).padLeft(15, ' ').trim());

    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);

    printer.feedLine(4);

    printer.print(onPrintReportOK, onPrintError);
  }

  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
}
