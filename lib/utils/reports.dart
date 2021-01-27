import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
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

  void _summaryReportHeader(Printer printer) async {
    DateTime now = DateTime.now();
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addTextSideBySide('   Fecha' , 'Hora   ');
    printer.addTextSideBySide( DateFormat('dd/MM/yyyy').format(now),  DateFormat('hh:mm:ss a').format(now));
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, 'RESUMEN DE PARAMETROS');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.LEFT, '**DATOS DEL COMERCIO**');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.LEFT, merchant.nameL1);
    printer.addText(Printer.LEFT, merchant.nameL2);
    printer.addText(Printer.LEFT,'RIF:' + merchant.taxID.toString());
    printer.addText(Printer.LEFT,merchant.city);
  }
  printSummaryReport() async {
    Printer printer = new Printer();
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    TerminalRepository terminalRepository = new TerminalRepository();
    Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
    CommRepository commRepository = new CommRepository();
    Comm comm = Comm.fromMap(await commRepository.getComm(1));
    AcquirerRepository acquirerRepository = new AcquirerRepository();
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));
    EmvRepository emvRepository  = new EmvRepository();
    Emv emv = Emv.fromMap(await emvRepository.getEmv(1));

    await _summaryReportHeader(printer);

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
     printer.addTextFillLine('-');
     printer.addText(Printer.LEFT, '**PARAMETROS GENERALES**');
     printer.addTextSideBySideWithCenter("COD. COMERCIO",     ":",merchant.mid.toString());
     printer.addTextSideBySideWithCenter("NUMERO DE SERIE",   ":",merchant.maxTip.toString());
     printer.addTextSideBySideWithCenter("NUMERO DE TERMINAL",":",merchant.tid);
     printer.addTextSideBySideWithCenter("COD MONEDA",        ":",merchant.currencyCode.toString());
     printer.addTextSideBySideWithCenter("SIMBOLO DE MONEDA", ":",merchant.currencySymbol.toString());
     printer.addTextSideBySideWithCenter("COD ADQUIRIENTE",   ":",merchant.acquirerCode.toString());
     printer.addTextSideBySideWithCenter("TELF. PRIMARIO",    ":",'N/A');
     printer.addTextSideBySideWithCenter("TELF. SECUNDARIO",  ":",'N/A');
     printer.addTextSideBySideWithCenter("TPDU",              ":",comm.tpdu);
     printer.addTextSideBySideWithCenter("NII",               ":",comm.nii);
     printer.addTextSideBySideWithCenter("TIPO SOFT",         ":",'NORMAL');
     acquirer.cashback==true ? printer.addTextSideBySideWithCenter("CASH BACK",":","SI") : null;
     terminal.installments==true ? printer.addTextSideBySideWithCenter("CUOTAS",":","SI") : null;
     acquirer.refund==true ? printer.addTextSideBySideWithCenter("DEVOLUCION",":","Si") : null ;
     acquirer.provimillas==true ? printer.addTextSideBySideWithCenter("PROVIMILLA",":","SI") : null;
     acquirer.cheque==true ? printer.addTextSideBySideWithCenter("CHEQUE",":","Si") : null;
     acquirer.checkIncheckOut==true ? printer.addTextSideBySideWithCenter("CHECK IN/OUT", ":","SI") : null;
     acquirer.saleOffline==true ? printer.addTextSideBySideWithCenter("VTA. FUERA LINEA",":","SI") : null;
     acquirer.cvv2==true ? printer.addTextSideBySideWithCenter("CVV2",":","SI") : null;
     acquirer.last4Digits==true ? printer.addTextSideBySideWithCenter("4 ULT.DIGITOS",":","SI") : null;
     terminal.passwordRefund==true ? printer.addTextSideBySideWithCenter("CLAVE ANULACION",":","Si") : null;
     terminal.passwordBatch==true ? printer.addTextSideBySideWithCenter("CLAVE CIERRE",":","SI") : null;
     terminal.passwordRefund==true ? printer.addTextSideBySideWithCenter("CLAVE DEVOLUCION", ":","SI") : null ;
     terminal.maskPan==true ? printer.addTextSideBySideWithCenter("ENMASCARAR TARJETA",":","SI") : null ;
     acquirer.prePrint==true ? printer.addTextSideBySideWithCenter("PRE-IMPRESION",":","SI") : null;
     terminal.amountConfirmation==true ?printer.addTextSideBySideWithCenter("CONFIRMAR IMPORTE", ":","SI") : null;
     printer.addTextSideBySideWithCenter("CLAVE SUPERVISOR",  ":",terminal.techPassword.toString());
     printer.addTextSideBySideWithCenter("PROPINA",           ":","N/A");
     printer.addTextSideBySideWithCenter("TEMP RPTA",         ":",terminal.timeoutPrompt.toString());
     printer.addTextSideBySideWithCenter("TEMP ENT DATOS",    ":",terminal.timeoutPrompt.toString()); //
     printer.addTextSideBySideWithCenter("FECHA Y HORA",      ":", new DateFormat("ddMMyyyyhhmmss").format(DateTime.now()));
     printer.addTextSideBySideWithCenter("COD PAIS TERMINAL",  ":",merchant.countryCode.toString());
     emv.fallback==true ?printer.addTextSideBySideWithCenter("FALLBACK",":","SI") : null;
     emv.forceOnline==true ?printer.addTextSideBySideWithCenter("FORZAR ONLINE",":","SI") : null;
     printer.feedLine(1);
     printer.addTextSideBySideWithCenter("V08.01.05 ","","01.01");
     printer.feedLine(6);

    printer.print(onPrintReportOK, onPrintError);
  }

  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }

}
