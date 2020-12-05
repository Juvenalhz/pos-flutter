import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay/models/trans.dart';

class LastSaleDetail extends StatelessWidget {
  final Trans trans;
  final Function(BuildContext) onClick;

  LastSaleDetail(this.trans, this.onClick);

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
                child:
                  Center(
                    child: Text(
                              'Consulta Última Venta',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            )
                        ),
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
                    child:
                      Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(flex: 1),
                              Text(trans.type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                              Spacer(flex: 1),
                              RowDetail(label: DateFormat('dd/MM/yyyy').format(trans.dateTime), strAmount: DateFormat('hh:mm:ss').format(trans.dateTime)),
                              Spacer(flex: 1),
                              RowDetail(label: "Ticket:", strAmount: trans.stan.toString()),
                              Spacer(flex: 2),
                              RowDetailAmount(label: "Total:", strAmount: formattedTotal),
                              Spacer(flex: 2),
                              RowDetail(label: "Tarjeta:", strAmount: trans.maskedPAN),
                              Spacer(flex: 1),
                              RowDetail(label: "Autorizacion:", strAmount: trans.authCode),
                              Spacer(flex: 1),
                              RowDetail(label: "Referencia:", strAmount: trans.referenceNumber),
                              Spacer(flex: 2),
                              Text(trans.respMessage, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22)),
                              Spacer(flex: 1),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnEnter(context)]),
                              ),
                            ],
                      ),

                  )
            ])),
          ],
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.done_outline, size: 35, color: Colors.white),
        onPressed: () {
          onClick(context);
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
