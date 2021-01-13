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

class Receipt{
  final BuildContext context;
  bool type;

  Receipt(this.context);
  Printer printer = new Printer();


  printTransactionReceipt(bool type, Trans trans) async{
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
    if (bin.cardType == 1) CreditReceipt( trans,  merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt

    //if (bin.cardType == Bin.TYPE_DEBIT)
    else if (bin.cardType == 2) DebitReceipt( trans,  merchant, type); //the var type is a bool, false = merchantReceipt and true = clientReceipt

    // else if (bin.cardType == Bin.TYPE_FOOD)
    else if (bin.cardType == 3)FoodReceipt( trans, merchant, type);//the var type is a bool, false = merchantReceipt and true = clientReceipt

    // else if (bin.cardType == Bin.TYPE_PROPIETARY)
    else if (bin.cardType == 4)FoodReceipt( trans, merchant, type);



  }

  void onPrintReceiptOK() {
  print('imprimiendo...');

  }

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }
//////////////////////////////////////////////////////////////RECIBOS CREDITO ///////////////////////////////////////////////////////////


  CreditReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);  //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ) : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    if(isCliente == false && trans.type == 'Compra') printer.addText(Printer.LEFT, 'Firma: _______________________________________');
    else if(trans.type == 'Anulación') printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    else null;
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    trans.type == 'Compra' ? printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX') : printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    isCliente == true ? printer.addText(Printer.CENTER, 'CAMPO TEXTO') : null ;
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
    isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
  }


//////////////////////////////////////////////////////////////RECIBOS DEBITO ///////////////////////////////////////////////////////////
  DebitReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);  //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ) : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    trans.type == 'Compra' ? printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX') : printer.addText(Printer.RIGHT, 'AID:XXXXXXXXXXXXXX');
    isCliente == true ? printer.addText(Printer.CENTER, 'CAMPO TEXTO') : null ;
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
    isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
  }

  ////////////////////////////////////////////////RECIBO ALIMENTACIÓN COMERCIO////////////////////////////////////////////////////
  FoodReceipt(Trans trans, Merchant merchant, bool isCliente) {
    printer.setFontSize(0);
    var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
    var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
    printer.addText(Printer.CENTER,merchant.nameL1); //nombre comercio
    printer.addText(Printer.CENTER, merchant.nameL1);//nombre comercio
    printer.addText(Printer.CENTER, merchant.city);  //localidad comercio
    printer.addTextSideBySide('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid);//rif y afiliado
    printer.addText(Printer.CENTER, trans.type + ' ' + trans.appLabel); //tipo de transaccion
    printer.addText(Printer.CENTER, trans.bin.toString() + trans.maskedPAN); //Bin y PAN
    printer.addTextSideBySide('BANCO ADQUIRIENTE','J-123456789-0'); //Info banco
    trans.type == 'Anulación' ? printer.addText(Printer.CENTER, 'No.Operac.Origen: 999999' ) : null; //
    printer.addTextSideBySide('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22)); //Fecha y hora
    printer.addTextSideBySideWithCenter('S/N POS:', 'No.Autor','No.Operac.');
    printer.addTextSideBySideWithCenter('12345678', '9999999','9999999');
    printer.addTextSideBySideWithCenter('Terminal 99', 'Lote 999','Ticket 9999');
    isCliente == true ? printer.addText(Printer.CENTER, 'COPIA - CLIENTE') : null;
    printer.addTextSideBySide('MONTOBs.', monto);
    printer.addText(Printer.CENTER, 'NO REQUIERE FIRMA');
    if(isCliente == true && trans.type == 'Compra') printer.addText(Printer.LEFT, 'Saldo: 999.999.999,99'); else null;
    printer.addText(Printer.LEFT, 'Ap .Preferred Name / Label');
    printer.addTextSideBySide('AID:XXXXXXXXXXXXXX','| CT:XXXXXXXXXXXXXXXX') ;
    if(isCliente == true && trans.type == 'Compra')  printer.addText(Printer.CENTER, 'CAMPO TEXTO'); else null;
    printer.addTextSideBySide('V X.0 - X0','Versión del Proveedor del POS');
    isCliente == true ? printer.feedLine(2) : printer.print(onPrintReceiptOK, onPrintError) ;
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