import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/utils/constants.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/utils/serialNumber.dart';

class Receipt {
  bool type;
  Printer printer;

  Receipt() {
    printer = new Printer();
  }

  printTransactionReceipt(bool type, bool copy, bool lastSale, Trans trans, Function onPrintOk, Function onPrintError) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    BinRepository binRepository = new BinRepository();
    Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));

    TerminalRepository terminalRepository = new TerminalRepository();
    Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));

    // static const int TYPE_CREDIT = 1;
    // static const int TYPE_DEBIT = 2;
    // static const int TYPE_FOOD = 3;
    // static const int TYPE_PROPIETARY = 4;
    this.type = type;
    //if (bin.cardType == Bin.TYPE_CREDIT)


    if (bin.cardType == 1 ) {
      await CreditReceipt(trans, merchant, type, copy, bin, lastSale); //the var type is a bool, false = merchantReceipt and true = clientReceipt


      printer.print(onPrintOk, onPrintError);
    }
    //if (bin.cardType == Bin.TYPE_DEBIT)
    else if (bin.cardType == 2) {
      await DebitReceipt(trans, merchant, type, copy, bin, lastSale); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.print(onPrintOk, onPrintError);
    } else if (bin.cardType == 3) {
      await FoodReceipt(trans, merchant, type, copy, bin, lastSale); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.print(onPrintOk, onPrintError);
    }
  }

//////////////////////////////////////////////////////////////RECIBOS CREDITO ///////////////////////////////////////////////////////////
  CreditReceipt(Trans trans, Merchant merchant, bool isCustomer, bool isCopy, Bin bin, bool lastSale) async {
    printer.setFontSize(0);
    await Header(trans, merchant,isCopy, bin, lastSale);

    await Body(trans, merchant, isCustomer, isCopy, lastSale);

    if (isCustomer == false && trans.type == 'Venta')
      printer.addText(Printer.LEFT, 'Firma: _______________________________________');
    else if (trans.type == 'Anulación') printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');

    await footer(trans, merchant, isCustomer);
  }

//////////////////////////////////////////////////////////////RECIBOS DEBITO ///////////////////////////////////////////////////////////
  DebitReceipt(Trans trans, Merchant merchant, bool isCustomer, bool isCopy, Bin bin, bool lastSale) async {
    printer.setFontSize(0);
    await Header(trans, merchant,isCopy, bin, lastSale);
    await Body(trans, merchant, isCustomer, isCopy, lastSale);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    await footer(trans, merchant, isCustomer);
  }

  ////////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////////////////////////////

  FoodReceipt(Trans trans, Merchant merchant, bool isCustomer, bool isCopy, Bin bin, bool lastSale) async {
    printer.setFontSize(0);
    await Header(trans, merchant,isCopy, bin, lastSale);

    await Body(trans, merchant, isCustomer, isCopy, lastSale);

    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    if (isCustomer == true && trans.type == 'Venta') {
      var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.foodBalance / 100);
      printer.addText(Printer.LEFT, 'Saldo Bs:        $monto');
    }
    await footer(trans, merchant, isCustomer);
  }

  //////////////////////SIN RESPUESTA/////////////////////////////////
  HostNotAnswerReceipt(Trans trans, Merchant merchant) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, 'INFORMACION COMPLEMENTARIA'); //localidad comercio
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.CENTER, 'S/N POS: 12345678');
    printer.addText(Printer.CENTER, 'HOST NO RESPONDE');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
  }

  //////////////////////TRANSACCIÓN RECHAZADA/////////////////////////////////
  TransactionDeclinedReceipt(Trans trans, Merchant merchant, bool isCustomer, bool isCopy, bool lastSale, Bin bin, Function onPrintOk, Function onPrintError) async{
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    printer.setFontSize(0);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    await Header(trans, merchant,isCopy, bin, lastSale);
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.CENTER, 'S/N POS: 12345678');
    printer.addText(Printer.CENTER, 'NEGADA');
    await footer(trans, merchant, isCustomer);
    //printer.feedLine(5);
    printer.print(onPrintOk, onPrintError);
  }

  ///////////////////////////////////////////////////RECIBOS AJUSTE DE PROPINA ////////////////////////////////////////////////////
  tipAdjustReceipt(Trans trans, Function onPrintOk, Function onPrintError) async {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    AcquirerRepository acquirerRepository = new AcquirerRepository();
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(trans.acquirer));
    var date = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var amount = formatter.format(trans.total / 100);
    String sn = await SerialNumber.serialNumber;

    printer.setFontSize(Printer.FONT_SIZE_SMALL);

    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL2); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, 'PROPINA DE CREDITO'); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.maskedPAN); //MASKED PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', acquirer.rif.trim()); //Info banco
    printer.addTextSideBySide('Fecha: ' + date.substring(0, 10), 'Hora: ' + date.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.LEFT, 'S/N POS:        No.Autor     No.Operac.   Mesero');
    printer.addText(
        Printer.LEFT, sn.padRight(16, ' ') + ' ' + trans.authCode + '     ' + trans.referenceNumber + '       ' + trans.server.toString());
    printer.addTextSideBySideWithCenter('Terminal ' + merchant.tid, 'Lote ' + merchant.batchNumber.toString(), 'Ticket ' + trans.id.toString());
    printer.addTextSideBySide('MONTOBs.', amount.trim());
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(5);
    printer.print(onPrintOk, onPrintError);
  }

  ///////////////////////////////////////////////////RECIBO DE CONFORMIDAD DE VISITA ////////////////////////////////////////////////////
  techVisitReceipt(
      String techTrack1, String techTrack2, String visitType, String reqType, String authCode, Function onPrintOk, Function onPrintError) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    AcquirerRepository acquirerRepository = new AcquirerRepository();
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));
    String sn = await SerialNumber.serialNumber;
    String panTech = techTrack2.substring(0, techTrack2.indexOf('='));
    String maskedPanTech = panTech.substring(0, 4) + '....' + panTech.substring(panTech.length - 4);
    String name = '';

    printMerchantInfo(merchant);
    printer.addText(Printer.CENTER, 'CONFORMIDAD VISITA');
    printer.addTextSideBySide('S/N POS: ' + sn.padRight(16, ' '), maskedPanTech);
    printAcquirerInfo(acquirer);
    printer.addText(Printer.LEFT, 'Técnico:    ' + name);
    printer.addTextSideBySide('Tipo Act:   ' + visitType, 'Num. Req.: ' + reqType);
    printDateTime();
    printer.addTextSideBySide('N Operac:   ' + authCode, 'Terminal: ' + merchant.tid);
    printer.addText(Printer.CENTER, 'CONFORME');
    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(2);
    printer.print(onPrintOk, onPrintError);
  }

  printMerchantInfo(Merchant merchant) async {
    printer.setFontSize(Printer.FONT_SIZE_SMALL);

    printer.addText(Printer.CENTER, merchant.nameL1);
    printer.addText(Printer.CENTER, merchant.nameL2);
    printer.addText(Printer.CENTER, merchant.city);
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid);
  }

  printAcquirerInfo(Acquirer acquirer) async {
    printer.addTextSideBySide('BANCO ADQUIRIENTE', acquirer.rif); //Info banco
  }

  printDateTime() {
    var date = DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now());

    printer.addTextSideBySide('Fecha: ' + date.substring(0, 10), 'Hora: ' + date.substring(11, 22));
  }

  Future<void> Header(Trans trans, Merchant merchant, bool isCopy,Bin bin, bool lastSale) async {

    AcquirerRepository acquirerRepository = new AcquirerRepository();
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(trans.acquirer));

    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL2); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    if ((isCopy) && (lastSale == false)) {
      printer.addText(Printer.CENTER, 'DUPLICADO');
    }
    if (lastSale) {
      printer.addText(Printer.CENTER, 'ÚLTIMA VENTA');
    }
    printer.addText(Printer.CENTER, TransactionType(bin, trans)); //tipo de transaccion
    trans.entryMode == Pinpad.CHIP ? printer.addText(Printer.CENTER, trans.maskedPAN) : null ; //Bin y PAN
    printer.addTextSideBySide(acquirer.name, acquirer.rif.trim());
  }

  Future<void> Body(Trans trans, Merchant merchant, bool isCustomer, bool isCopy, bool lastSale) async {
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total / 100);
    var sn = await SerialNumber.serialNumber;

    printer.setFontSize(0);
    if (trans.type == 'Anulación') {
      printer.addText(Printer.CENTER, 'No.Operac.Origen: ' + trans.referenceNumberCancellation);
    }
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    //printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.');
    trans.server==0 ? printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.') : printer.addText(Printer.LEFT, 'S/N POS:      No.Autor    No.Operac.   Mesero');
    trans.server==0 ?  printer.addTextSideBySideWithCenter(sn, trans.authCode, trans.referenceNumber) :
    printer.addText(Printer.LEFT, sn.padRight(16, ' ') + ' ' + trans.authCode + '     ' + trans.referenceNumber + '       ' + trans.server.toString()) ;
    //printer.addTextSideBySideWithCenter(sn, trans.authCode, trans.referenceNumber);
    printer.addTextSideBySideWithCenter(
        'Terminal ' + merchant.id.toString(), 'Lote ' + merchant.batchNumber.toString(), 'Ticket ' + trans.id.toString().padLeft(6, '0'));
    if ((isCustomer == true) && (lastSale == false)) printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    if (isCopy) {
      printer.addText(Printer.CENTER, 'DUPLICADO');
    }
    printer.addTextSideBySide('MONTOBs.', monto);
  }

  void footer(Trans trans, Merchant merchant, bool isCustomer) {
    if (trans.entryMode == Pinpad.CHIP) {

      printer.addText(Printer.LEFT, trans.appLabel);

      int aidIndex = trans.emvTags.indexOf('9F06') + 4;
      int aidLength = hex.decode(trans.emvTags.substring(aidIndex, aidIndex + 2))[0];
      String aid = trans.emvTags.substring(aidIndex + 2, aidIndex + 2 + aidLength * 2);
      int ctIndex = trans.emvTags.indexOf('9F26') + 4;
      int ctLength = hex.decode(trans.emvTags.substring(ctIndex, ctIndex + 2))[0];
      String ct = trans.emvTags.substring(ctIndex + 2, ctIndex + 2 + ctLength * 2);

      if (trans.type == 'Venta')
        printer.addTextSideBySide('AID:$aid', 'CT:$ct');
      else
        printer.addTextSideBySide('AID:$aid', '    ');
    }

    printer.addTextSideBySide(Constants.specsVersion, Constants.appVersion);
    printer.feedLine(5);
  }


  TransactionType (Bin bin, Trans trans) {
    var Txtype = (trans.type == 'Anulación' ? 'ANULACION' : 'VENTA') ;
    switch(bin.cardType) {
      case 1: {
        return Txtype + " CREDITO" ;
      }
      break;

      case 2: {
        return Txtype + " DEBITO" ;
      }
      break;

      default: {
        return Txtype + " ALIMENTACION" ;
      }
      break;
    }
  }

}
