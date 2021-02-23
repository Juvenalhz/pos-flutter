import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/utils/serialNumber.dart';

class Receipt {
  bool type;
  Printer printer = new Printer();

  Receipt();

  printTransactionReceipt(bool type, Trans trans) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));
    BinRepository binRepository = new BinRepository();
    Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));
    // static const int TYPE_CREDIT = 1;
    // static const int TYPE_DEBIT = 2;
    // static const int TYPE_FOOD = 3;
    // static const int TYPE_PROPIETARY = 4;
    this.type = type;
    //if (bin.cardType == Bin.TYPE_CREDIT)
    if (bin.cardType == 1) {
      CreditReceipt(trans, merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.feedLine(2);
      printer.print(onPrintReceiptOK, onPrintError);
    }
    //if (bin.cardType == Bin.TYPE_DEBIT)
    else if (bin.cardType == 2) {
      DebitReceipt(trans, merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.feedLine(2);
      printer.print(onPrintReceiptOK, onPrintError);
    } else if (bin.cardType == 3) {
      FoodReceipt(trans, merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.feedLine(2);
      printer.print(onPrintReceiptOK, onPrintError);
    }

    //printer.print(onPrintReceiptOK, onPrintError);
  }

  void onPrintReceiptOK() {}

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
//////////////////////////////////////////////////////////////RECIBOS CREDITO ///////////////////////////////////////////////////////////

  CreditReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999') : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999', '9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999', 'Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    if (isCliente == false && trans.type == 'Compra')
      printer.addText(Printer.LEFT, 'Firma: _______________________________________');
    else if (trans.type == 'Anulación')
      printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    else
      null;
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    trans.type == 'Compra'
        ? printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX')
        : printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    isCliente == true ? printer.addText(Printer.CENTER, 'CAMPO TEXTO') : null;
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
    // isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
  }

//////////////////////////////////////////////////////////////RECIBOS DEBITO ///////////////////////////////////////////////////////////
  DebitReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999') : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999', '9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999', 'Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    trans.type == 'Compra'
        ? printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX')
        : printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    isCliente == true ? printer.addText(Printer.CENTER, 'CAMPO TEXTO') : null;
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
    //isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
  }

  ////////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////////////////////////////
  FoodReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999') : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999', '9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999', 'Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    if (isCliente == true && trans.type == 'Compra')
      printer.addText(Printer.LEFT, 'Saldo: 999.999.999,99');
    else
      null;
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX');
    if (isCliente == true && trans.type == 'Compra')
      printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    else
      null;
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
    //isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
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
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.CENTER, 'S/N POS: 12345678');
    printer.addText(Printer.CENTER, 'HOST NO RESPONDE');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
  }

  //////////////////////TRANSACCIÓN RECHAZADA/////////////////////////////////
  TransactionDeclinedReceipt(Trans trans, Merchant merchant) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.CENTER, 'S/N POS: 12345678');
    printer.addText(Printer.CENTER, 'TEXTO RECHAZO');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
  }

  //////////////////////////////////////////////////////////////RECIBOS COMERCIO DEBITO ///////////////////////////////////////////////////////////
  DuplicateReceipt(Trans trans, Merchant merchant) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.city); //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID, 'Afiliado: ' + merchant.mid); //rif y afiliado
    printer.addText(Printer.CENTER, 'DUPLICADO'); //localidad comercio
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE', 'J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10), 'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor', 'No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999', '9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999', 'Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX', '| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0', 'Versión del Proveedor del POS');
  }

  printTransactionReceiptCopy(bool type, Trans trans) {
    Printer printer = new Printer();

    this.type = type;
    if (type)
      printer.addText(Printer.CENTER, 'Merchant Receipt');
    else
      printer.addText(Printer.CENTER, 'Customer Receipt');

    printer.feedLine(2);

    printer.print(onPrintCopyReceiptOK, onPrintError);
  }

  void onPrintCopyReceiptOK() {}

  ///////////////////////////////////////////////////RECIBOS AJUSTE DE PROPINA ////////////////////////////////////////////////////
  tipAdjustReceipt(Trans trans) async {
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
    printer.addTextSideBySide('V08.01-05', '01.01');
    printer.feedLine(2);
    printer.print(onPrintReceiptOK, onPrintError);
  }

  ///////////////////////////////////////////////////RECIBO DE CONFORMIDAD DE VISITA ////////////////////////////////////////////////////
  techVisitReceipt(String techTrack1, String techTrack2, String visitType, String reqType, String authCode) async {
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
    printer.addTextSideBySide('V08.01-05', '01.01');
    printer.feedLine(2);
    printer.print(onPrintReceiptOK, onPrintError);
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
}
