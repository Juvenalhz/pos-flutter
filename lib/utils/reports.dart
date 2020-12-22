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

    printer.addText(Printer.CENTER, merchant.nameL1);
    printer.addText(Printer.CENTER, merchant.nameL2);
    printer.addText(Printer.CENTER, merchant.city);
    printer.addTextSideBySide('RIF:' + merchant.taxID, 'Afiliado:' + merchant.mid);
  }

  void _addTerminalData(Printer printer) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime now = DateTime.now();

    printer.addTextSideBySide('Fecha:' + DateFormat('dd/MM/yyyy').format(now), 'Hora:' + DateFormat('hh:mm:ss a').format(now));
    printer.addTextSideBySideWithCenter('Terminal', 'Lote', 'S/N POS');
    printer.addTextSideBySideWithCenter(merchant.tid.padLeft(5, ' '), merchant.batchNumber.toString(), await SerialNumber.serialNumber);
  }

  printDetailReport(List<Trans> transList) async {
    Printer printer = new Printer();
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
    TransRepository transRepository = new TransRepository();

    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    await _addHeader(printer);
    printer.addText(Printer.CENTER, 'REPORTE DETALLADO');
    await _addTerminalData(printer);

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.RIGHT, 'Ticket      Nro. Tarjeta               Bs.');
    printer.addText(Printer.RIGHT, 'Tipo                     Fecha           Hora');
    printer.addTextFillLine('-');

    transList.forEach((element) {
      String ticket = element.id.toString().padLeft(4, ' ');
      String acct = element.maskedPAN;
      String amount = formatter.format(element.total / 100).padLeft(17, ' ');
      String type = element.type.padRight(15, ' ');
      String date = DateFormat('dd/MM/yyyy').format(element.dateTime);
      String hour = DateFormat('hh:mm:ss').format(element.dateTime);

      printer.addText(Printer.RIGHT, '$ticket        $acct           $amount');
      printer.addText(Printer.RIGHT, '$type          $date     $hour');
    });

    printer.addText(Printer.RIGHT, 'Totales');
    printer.addTextSideBySide('Cantidad de Transacctiones:', (await transRepository.getCountTrans()).toString());
    printer.addTextSideBySide('Bs.:', formatter.format(await transRepository.getBatchTotal() / 100).toString());
    printer.addTextSideBySide('V08.01-05', '01.01');

    printer.feedLine(2);

    printer.print(onPrintReportOK, onPrintError);
  }

  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
}
