import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/utils/serialNumber.dart';

class Reports {
  final BuildContext context;

  Reports(this.context);

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

  printDetailReport(List<Trans> transList) async {
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
    printer.addTextSideBySide('V08.01-05', '01.01');

    printer.feedLine(5);

    printer.print(onPrintReportOK, onPrintError);
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

    printer.addTextSideBySide('V08.01-05', '01.01');

    printer.feedLine(4);

    printer.print(onPrintReportOK, onPrintError);
  }

  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
}
