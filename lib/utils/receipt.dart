import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/utils/printer.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/models/merchant.dart';

class Receipt{
  final BuildContext context;
  bool type;

  Receipt(this.context);
  Printer printer = new Printer();


  printTransactionReceipt(bool type, Trans trans) async{
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = new Merchant.fromMap(await merchantRepository.getMerchant(1));

    this.type = type;
    if (type)
    {
      CreditSaleMerchantReceipt( trans,  merchant);
    }
    else
    {
      CreditSaleClientReceipt(trans, merchant);
    }

    printer.feedLine(2);

    printer.print(onPrintReceiptOK, onPrintError);
  }

  void onPrintReceiptOK() {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (this.type)
      transactionBloc.add(TransCustomerReceipt());
    else
      transactionBloc.add(TransCustomerReceipt());

  }

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
//////////////////////////////////////////////////////////////RECIBOS CLIENTE CREDITO ///////////////////////////////////////////////////////////
  CreditSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  CancellationCreditSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ); //Bin y PAN
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  RefundCreditSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  //////////////////////////////////////////////////////////////RECIBOS COMERCIO CREDITO ///////////////////////////////////////////////////////////
  CancellationCreditSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ); //Bin y PAN
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  RefundCreditSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'Firma: __________________________');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }

  CreditSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'Firma: __________________________');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
//////////////////////////////////////////////////////////////RECIBOS CLIENTE DEBITO ///////////////////////////////////////////////////////////
  DebitSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }

  CancellationDebitSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ); //Bin y PAN
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
//////////////////////////////////////////////////////////////RECIBOS COMERCIO DEBITO ///////////////////////////////////////////////////////////
  DebitSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }

  CancellationDebitSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ); //Bin y PAN
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  ////////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////////////////////////////
  FoodDebitSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  CancellationFoodDebitSaleClientReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' );
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addText(Printer.CENTER, 'COPIA - CLIENTE');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  /////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////
  FoodDebitSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ); //Bin y PAN
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
  }
  CancellationFoodDebitSaleMerchantReceipt(Trans trans, Merchant merchant) {
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
    printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' );
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.RIGHT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX');
    printer.addText(Printer.CENTER, 'CAMPO TEXTO');
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
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
}


// class ReceiptGeneric {
// String _merchantName;
// String _location;
// String _rif;
// String _afiliado;
// String _infoAdditional;
// String _transType;
// String _marca;
// String _xxx;
// String _bank;
// String _rifBank;
// String _nroOperation;
// String _date;
// String _hour;
// String _pos;
// String _author;
// String _nroOperation2;
// String _mesero;
// String _terminal;
// String _lote;
// String _ticket;
// String _mount;
// String _propina;
// String _totalBss;
// String _firma;
// String _saldoBss;
// String _ptos;
// String _namelabel;
// String _aid;
// String _ct;
// String _text;
// String _versionDocument;
// String _versionPOS;
//
// ReceiptGeneric();
//
//
// String get merchantName => this._merchantName;
// String get location => this._location;
// String get rif => this._rif;
// String get afiliado => this._afiliado;
// String get infoAdditional => this._infoAdditional;
// String get transType => this._transType;
// String get marca => this._marca;
// String get xxx => this._xxx;
// String get bank => this._bank;
// String get rifBank => this._rifBank;
// String get nroOperation => this._nroOperation;
// String get date => this._date;
// String get hour => this._hour;
// String get pos => this._pos;
// String get author => this._author;
// String get nroOperation2 => this._nroOperation2;
// String get mesero => this._mesero;
// String get terminal => this._terminal;
// String get lote => this._lote;
// String get ticket => this._ticket;
// String get mount => this._mount;
// String get propina => this._propina;
// String get totalBss => this._totalBss;
// String get firma => this._firma;
// String get saldoBss => this._saldoBss;
// String get ptos => this._ptos;
// String get namelabel => this._namelabel;
// String get aid => this._aid;
// String get ct => this._ct;
// String get text => this._text;
// String get versionDocument => this._versionDocument;
// String get versionPOS => this._versionPOS;
//
//
// }