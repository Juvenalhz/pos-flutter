import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/utils/serialNumber.dart';

class Receipt {
  final BuildContext context;
  bool type;
  Printer printer = new Printer();

  Receipt(this.context);

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
      DebitReceipt( trans,  merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt
      printer.feedLine(2);
      printer.print(onPrintReceiptOK, onPrintError);
    }
    else if (bin.cardType == 3) {
      FoodReceipt( trans,  merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt
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


  CreditReceipt(Trans trans, Merchant merchant, bool isCliente)  {
    printer.setFontSize(0);
   Header(trans,merchant,isCliente);
   Body(trans,merchant,isCliente);

   if(isCliente == false && trans.type == 'Compra') printer.addText(Printer.LEFT, 'Firma: _______________________________________');
   else if(trans.type == 'Anulación') printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
   else null;

   footer(trans,merchant,isCliente);
  }


//////////////////////////////////////////////////////////////RECIBOS DEBITO ///////////////////////////////////////////////////////////
  DebitReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    Header(trans,merchant,isCliente);
    Body(trans,merchant,isCliente);

    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');

    footer(trans,merchant,isCliente);
  }

  ////////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////////////////////////////
  FoodReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    Header(trans,merchant,isCliente);
    Body(trans,merchant,isCliente);

    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    if(isCliente == true && trans.type == 'Compra') printer.addText(Printer.LEFT, 'Saldo: 999.999.999,99'); else null;
    footer(trans,merchant,isCliente);
  }


  //////////////////////SIN RESPUESTA/////////////////////////////////
HostNotAnswerReceipt(Trans trans, Merchant merchant) {
  printer.setFontSize(0);
  var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
  var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
  printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
  printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
  printer.addText(Printer.CENTER, merchant.city);//localidad comercio
  printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
  printer.addText(Printer.CENTER, 'INFORMACION COMPLEMENTARIA');//localidad comercio
  printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
  printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
  printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
  printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
  printer.addText(Printer.CENTER, 'S/N POS: 12345678');
  printer.addText(Printer.CENTER, 'HOST NO RESPONDE');
  printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
  printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
  printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }

  //////////////////////TRANSACCIÓN RECHAZADA/////////////////////////////////
  TransactionDeclinedReceipt(Trans trans, Merchant merchant) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);//localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addText(Printer.CENTER, 'S/N POS: 12345678');
    printer.addText(Printer.CENTER, 'TEXTO RECHAZO');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }

  //////////////////////////////////////////////////////////////RECIBOS COMERCIO DEBITO ///////////////////////////////////////////////////////////
  DuplicateReceipt(Trans trans, Merchant merchant) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);//localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER,'DUPLICADO');//localidad comercio
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
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
  void Header(Trans trans, Merchant merchant, bool isCliente) {
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);  //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
  }
  void Body(Trans trans, Merchant merchant, bool isCliente)  {
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    //var sn = await SerialNumber.serialNumber;
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ) : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter( 'sn' , trans.authCode, trans.referenceNumber);
    printer.addTextSideBySideWithCenter('Terminal ' + merchant.id.toString(), 'Lote '+ merchant.batchNumber.toString(),'Ticket '+ trans.id.toString());
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
  }
  void footer(Trans trans, Merchant merchant, bool isCliente) {
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    trans.type == 'Compra' ? printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX') : printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    isCliente == true ? printer.addText(Printer.CENTER, 'CAMPO TEXTO') : null ;
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
}
