import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/utils/printer.dart';

class Reports {
  final BuildContext context;

  Reports(this.context);

  printDetailReport(List<Trans> transList) {
    Printer printer = new Printer();
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    printer.addText(Printer.CENTER, 'Reporte Detallado');

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.RIGHT, 'Ticket      Nro. Tarjeta               Bs');
    printer.addText(Printer.RIGHT, 'Tipo                    Fecha            Hora');

    transList.forEach((element) {
      String ticket = element.id.toString().padLeft(4, ' ');
      String acct = element.maskedPAN;
      String amount = formatter.format(element.total / 100).padLeft(17, ' ');
      String type = element.type.padRight(15, ' ');
      String date = DateFormat('dd/MM/yyyy').format(element.dateTime);
      String hour = DateFormat('hh:mm:ss').format(element.dateTime);

      printer.addText(Printer.RIGHT, '$ticket        $acct           $amount');
      printer.addText(Printer.RIGHT, '$type       $date          $hour');
    });

    printer.feedLine(2);

    printer.print(onPrintReportOK, onPrintError);
  }

  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
}
