import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';

class DigitalReceipt extends StatelessWidget {
  Trans trans;
  Acquirer acquirer;
  Merchant merchant;
  Terminal terminal;
  DigitalReceipt(this.trans,this.acquirer,this.merchant,this.terminal);

  @override
  Widget build(BuildContext context) {
   // final trans = ModalRoute.of(context).settings.arguments;
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.6),
                    end: Alignment(0.0, 0.0),
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Colors.blue,
                    ],
                  ),
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                    left: 6,
                    top: 6,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        transactionBloc.add(TransAskIdNumber());
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 10, 0),
                        child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
                          if (state is TransactionDigitalReceiptCustomer) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Muestra Digital',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // this text should not be shown, as the state should always be correct, but we need to return a widget
                            return Text(
                              'Confirmación',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            );
                          }
                        })),
                  )
                ]),
              ),
            ]),
            Expanded(
                child: Stack(children: <Widget>[
                  Container(
                    color: Color(0xFF0D47A1),
                  ),
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                    child: Center(
                      child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
                        if (state is TransactionDigitalReceiptCustomer) {
                          var fecha = DateFormat('dd/MM/yyyy hh:mm:ss a').format(trans.dateTime);
                          var monto = new NumberFormat("#,##0.00", "es_VE").format(trans.total);
                          return Container(
                              padding: EdgeInsets.all(15),
                                  child: Column( mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ShowOneText(merchant.nameL1, MainAxisAlignment.center),
                                      ShowOneText(merchant.city, MainAxisAlignment.center),
                                      ShowTwoText('RIF: ' + merchant.taxID,'Afiliado: ' + merchant.mid, FontWeight.normal),
                                      ShowOneText(trans.type + ' ' + trans.appLabel, MainAxisAlignment.center),
                                      ShowOneText(trans.bin.toString() + trans.maskedPAN, MainAxisAlignment.center),
                                      ShowTwoText('BANCO ADQUIRIENTE','J-123456789-0', FontWeight.normal),
                                      ShowTwoText('Fecha: ' + fecha.substring(0, 10),'Hora: ' + fecha.substring(11, 22), FontWeight.normal),
                                      ShowThreeText("S/N POS","No. Autor","No. Operac", FontWeight.normal),
                                      ShowThreeText(terminal.idTerminal,"10238","9999999",  FontWeight.bold),
                                      ShowThreeText("Terminal 99","Lote 999","Ticket 9999", FontWeight.bold),
                                      ShowTwoText("MontoBs.", monto,FontWeight.bold),
                                      ShowOneText("Ap .Preferred Name / Label", MainAxisAlignment.start),
                                      ShowOneText("AID:XXXXXXXXXXXXXX", MainAxisAlignment.end),
                                      ShowTwoText("V X.0 - X0","Versión del Proveedor del POS",FontWeight.normal),

                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [btnEnter(context, state)]),
                                      ),

                                    ],
                                  ));
                        }
                        else
                          // this text should not be shown, as the state should always be correct, but we need to return a widget
                          return Text(
                            'Confirmation',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                          );
                      }),
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context, state) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          if (state is TransactionDigitalReceiptCustomer) {
            transactionBloc.add(TransCardError());
          }
        },
        color: Colors.green,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }
 Widget ShowOneText(String text1, MainAxisAlignment position) {
   return Padding(padding: EdgeInsets.all(5), child:Row(
     mainAxisAlignment: position,
     children: [
       Text(text1),
     ],
   ));
  }

  Widget ShowTwoText(String text1, String text2, FontWeight font) {
    return Padding(padding: EdgeInsets.all(5), child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: TextStyle(fontWeight: font)),
        Text(text2, style: TextStyle(fontWeight: font))
      ],
    ));
  }

  Widget ShowThreeText(String text1, String text2, String text3, FontWeight font) {
    return Padding(padding: EdgeInsets.all(5), child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text1),
        Text(text2),
        Text(text3, style: TextStyle(fontWeight: font)),
      ],
    ));
  }
}
