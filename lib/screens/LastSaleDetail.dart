import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/utils/receipt.dart';

class LastSaleDetail extends StatelessWidget {
  final Trans trans;
  final String cardBrand;
  final Function(BuildContext) onClick;

  LastSaleDetail(this.trans, this.cardBrand, this.onClick);

  @override
  Widget build(BuildContext context) {
    int total = trans.total;
    String formattedAmount;
    String formattedTip;
    String formattedTotal;
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    formattedTotal = formatter.format(total / 100).trim();

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
                child: Center(
                    child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Consulta Última Venta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.print_outlined),
                    onPressed: () {
                      Receipt receipt = new Receipt();

                      receipt.printTransactionReceipt(true, true, true, trans, onPrintOK, onPrintError);
                    },
                  ),
                ])),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(flex: 1),
                    Text(trans.type + ' - ' + cardBrand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                    Spacer(flex: 1),
                    RowDetail(label: DateFormat('dd/MM/yyyy').format(trans.dateTime), strAmount: DateFormat('hh:mm:ss').format(trans.dateTime)),
                    Spacer(flex: 1),
                    RowDetail(label: "Ticket:", strAmount: trans.numticket.toString()),
                    Spacer(flex: 2),
                    RowDetailAmount(label: "Total:", strAmount: formattedTotal),
                    Spacer(flex: 2),
                    RowDetail(label: "Tarjeta:", strAmount: trans.maskedPAN),
                    Spacer(flex: 1),
                    RowDetail(label: "Autorizacion:", strAmount: trans.authCode),
                    Spacer(flex: 1),
                    RowDetail(label: "Nro Operacion:", strAmount: trans.referenceNumber),
                    Spacer(flex: 2),
                    Text(trans.respMessage, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22)),
                    Spacer(flex: 1),
                    if (trans.respCode == '00') btnEnter(context, true) else btnEnter(context, false),
                    Spacer(flex: 1),
                  ],
                ),
              )
            ])),
          ],
        ),
      ),
    );
  }

  void onPrintCancel(BuildContext context) {
    // final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    //
    // transactionBloc.add(TransPrintCancel());
  }

  void onPrintRetry(BuildContext context) {
    // final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    //
    // transactionBloc.add(TransPrintRetry());
  }

  Widget btnEnter(BuildContext context, bool approved) {
    Color btnColor = (approved) ? Colors.green : Colors.red;
    IconData btnIcon = (approved) ? Icons.done_outline : Icons.error_outline;

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(btnIcon, size: 35, color: Colors.white),
        onPressed: () {
          onClick(context);
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }
}

class RowDetail extends StatelessWidget {
  final String label;
  final String strAmount;

  const RowDetail({
    Key key,
    @required this.label,
    @required this.strAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22)),
        Flexible(fit: FlexFit.tight, child: SizedBox()),
        Text(strAmount, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22))
      ]),
    );
  }
}

class RowDetailAmount extends StatelessWidget {
  final String label;
  final String strAmount;

  const RowDetailAmount({
    Key key,
    @required this.label,
    @required this.strAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        Flexible(fit: FlexFit.tight, child: SizedBox()),
        Text(strAmount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
      ]),
    );
  }
}

void onPrintOK() {}

void onPrintError(int type) {}
