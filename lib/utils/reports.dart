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
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
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
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    int batchNumber = merchant.batchNumber;

    printer.setFontSize(0);
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
    printer.addTextSideBySide(
        'Cantidad de Transacciones:', (await transRepository.getCountTrans(where: 'reverse = 0 and batchNum = $batchNumber')).toString());
    printer.addTextSideBySide('Bs.:',
        formatter.format(await transRepository.getBatchTotal(where: 'reverse=0 and voided=0 and batchNum = $batchNumber') / 100).toString().trim());
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
      printer.setFontSize(Printer.FONT_SIZE_SMALL);
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

  void _parametersReportHeader(Printer printer) async {
    DateTime now = DateTime.now();
    String sn= await SerialNumber.serialNumber;
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, merchant.nameL1);
    printer.addText(Printer.CENTER, merchant.nameL2);
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addTextSideBySideWithCenter("",merchant.city , "");
    printer.addTextSideBySide( "RIF: "+ merchant.taxID.toString() , "Afiliado: " +merchant.mid.trim());
    printer.addTextSideBySideWithCenter("","S/N POS:"+ sn , "");
    printer.setFontSize(Printer.FONT_SIZE_NORMAL);
    printer.addText(Printer.CENTER, 'REPORTE DE PARAMETROS EMV');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addText(Printer.LEFT, '**DATOS GENERALES*');
    printer.setFontSize(Printer.FONT_SIZE_SMALL);

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
    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(6);

    printer.print(onPrintReportOK, onPrintError);
  }

  printParameterReport() async {
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
    PubKeyRepository pubKeyRepository = new PubKeyRepository();
    List<Map<String, dynamic>> pubKey = await pubKeyRepository.getPubKeys();

    final pkeyLen=pubKey.length.toInt();

    await _parametersReportHeader(printer);

    printer.setFontSize(Printer.FONT_SIZE_SMALL);
    printer.addTextFillLine('-');
    printer.addTextSideBySideWithCenter("TIPO TERMINAL",     ":",emv.terminalType);
    printer.addTextSideBySideWithCenter("ADD CAPABILITIES",":",emv.terminalCapabilities);
    emv.fallback==true ?printer.addTextSideBySideWithCenter("FALLBACK",":","SI") : null;
    emv.forceOnline==true ?printer.addTextSideBySideWithCenter("FORZAR ONLINE",":","SI") : null;

    printer.addText(Printer.LEFT, '**TABLA AIDs**');
    printer.addTextSideBySideWithCenter("RID+PIX", ":",merchant.currencySymbol.toString());
    printer.addTextSideBySideWithCenter("LIMITE PISO",   ":",merchant.acquirerCode.toString());
    printer.addTextSideBySideWithCenter("VERSION",    ":",'N/A');
    printer.addTextSideBySideWithCenter("TAC DENIAL",  ":",'N/A');
    printer.addTextSideBySideWithCenter("TAC ONLINE",              ":",comm.tpdu);
    printer.addTextSideBySideWithCenter("TAC DEFAULT",               ":",comm.nii);
    printer.addTextSideBySideWithCenter("THRESHOLD VALUE",         ":",'NORMAL');
    acquirer.cashback==true ? printer.addTextSideBySideWithCenter("TARGET PERCENT",":","SI") : null;
    terminal.installments==true ? printer.addTextSideBySideWithCenter("MAX TAR. PERCENT",":","SI") : null;
    acquirer.refund==true ? printer.addTextSideBySideWithCenter("TDOL",":","Si") : null ;
    acquirer.provimillas==true ? printer.addTextSideBySideWithCenter("DDOL",":","SI") : null;

    printer.addText(Printer.LEFT, '**TABLA LLAVES**');
    printer.addTextFillLine('-');
    if (pubKey != null) {
      for(int i = 0; i <= pkeyLen-1 ; i++){
        printer.addTextSideBySideWithCenter("PUBLIC KEY INDEX",  ":",pubKey[i]["keyIndex"].toString());
        printer.addTextSideBySideWithCenter("KEY LENGTH",  ":",pubKey[i]["length"].toString());
        printer.addTextSideBySideWithCenter("KEY EXPONENT",           ":",pubKey[i]["exponent"].toString());
        printer.addTextSideBySideWithCenter("RID",         ":",pubKey[i]["rid"].toString());
        printer.addTextSideBySideWithCenter("EXPIRATION DATE",    ":",pubKey[i]["expDate"].toString()); //
        printer.addTextFillLine('-');
      }
    }

    printer.feedLine(1);
    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(6);
    printer.print(onPrintReportOK, onPrintError);
  }


  void onPrintReportOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
}
