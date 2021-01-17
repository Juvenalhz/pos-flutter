import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/trans.dart';

class Confirmation extends StatelessWidget {
  Trans trans;
  Confirmation({this.trans});

  @override
  Widget build(BuildContext context) {
    final trans = ModalRoute.of(context).settings.arguments;
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
                          if (state is TransactionAskConfirmation) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Confirmación',
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
                    if (state is TransactionAskConfirmation) {
                      int amount = state.trans.baseAmount;
                      int tip = state.trans.tip;
                      int total = state.trans.total;
                      String formattedAmount;
                      String formattedTip;
                      String formattedTotal;
                      var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

                      formattedAmount = formatter.format(amount / 100).trim();
                      formattedTip = formatter.format(tip / 100).trim();
                      formattedTotal = formatter.format(total / 100).trim();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(flex: 1),
                          Text(state.trans.type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                          Spacer(flex: 1),
                          RowDetail(label: "Tarjeta:", strAmount: state.trans.maskedPAN),
                          Spacer(flex: 1),
                          RowDetail(label: "Cedula:", strAmount: state.trans.cardholderID),
                          Spacer(flex: 1),
                          if (state.trans.binType == Bin.TYPE_FOOD)
                            RowDetail(label: "T. Cuenta:", strAmount: 'Alimenticia')
                          else if (state.trans.accType == 0)
                            RowDetail(label: "T. Cuenta:", strAmount: 'Credito')
                          else if (state.trans.accType == 2)
                            RowDetail(label: "T. Cuenta:", strAmount: 'Corriente')
                          else if (state.trans.accType == 1)
                            RowDetail(label: "T. Cuenta:", strAmount: 'Ahorro'),
                          Spacer(flex: 1),
                          if ((state.trans.binType == Bin.TYPE_CREDIT) && (state.trans.server != 0))
                            RowDetail(label: "Num. Mesero:", strAmount: state.trans.server.toString()),
                          Spacer(flex: 3),
                          if (state.acquierer.industryType) RowDetailAmount(label: "Monto:", strAmount: formattedAmount),
                          if (state.acquierer.industryType) Spacer(flex: 1),
                          if (state.acquierer.industryType) RowDetailAmount(label: "Propina:", strAmount: formattedTip),
                          if (state.acquierer.industryType) Spacer(flex: 1),
                          if (state.acquierer.industryType) Divider(thickness: 4, indent: 30, endIndent: 30),
                          if (state.acquierer.industryType) Spacer(flex: 1),
                          RowDetailAmount(label: "Total:", strAmount: formattedTotal),
                          Spacer(flex: 2),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnEnter(context)]),
                          ),
                        ],
                      );
                    } else
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

  Widget btnCancel(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.cancel, size: 35, color: Colors.white),
        onPressed: () {
          transactionBloc.add(TransCardError());
        },
        color: Colors.red,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          transactionBloc.add(TransConfirmOK());
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
