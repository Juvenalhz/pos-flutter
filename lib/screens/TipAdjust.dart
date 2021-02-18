import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/tipAdjustBloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/TipScreen.dart';
import 'package:pay/screens/TransApprovedScreen.dart';
import 'package:pay/screens/TransRejectedScreen.dart';
import 'package:pay/screens/amount.dart';
import 'package:pay/screens/commProgress.dart';
import 'package:pay/screens/components/AlertCancelRetry.dart';

import 'LastSaleDetail.dart';

class TipAdjust extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TipAdjustBloc, TipAdjustState>(builder: (context, state) {
          if (state is TipAdjustDataReady) {
            return ShowTransList(context, state.transList);
          } else if (state is TipAdjustPromptTip) {
            return TipScreen(state.trans, onTipClickEnter, onTipClickBack);
          } else if (state is TipAdjustShowMessage) {
            return TipAdjustMessage(context, state.message);
          } else if (state is TipAdjustConfirmation) {
            return TipAdjustShowConfirmation(context, state.trans);
          } else if (state is TipAdjustConnecting) {
            return CommProgress('Ajuste De Propina', status: 'Conectando').build(context);
          } else if (state is TipAdjustSending) {
            return CommProgress('Ajuste De Propina', status: 'Enviando').build(context);
          } else if (state is TipAdjustReceiving) {
            return CommProgress('Ajuste De Propina', status: 'Recibiendo').build(context);
          } else if (state is TipAdjustCommError) {
            return AlertCancelRetry('Ajuste De Propina', 'Error de conexión....', onClickCancel, onClickRetry);
          } else if (state is TipAdjustCompleted) {
            return TransApprovedScreen(state.trans, onClickResponseMessage);
          } else if (state is TipAdjustRejected) {
            return TransRejectedScreen(state.trans, onClickResponseMessage);
          } else
            return Container(child: Text(state.toString()));
        }),
      ),
    );
  }

  void onClickResponseMessage(BuildContext context) {
    final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
    tipAdjustBloc.add(TipAdjustInitialEvent());
  }

  Widget btnCancel(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.cancel, size: 35, color: Colors.white),
        onPressed: () {
          final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
          tipAdjustBloc.add(TipAdjustInitialEvent());
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

  Widget btnConfirmEnter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
          tipAdjustBloc.add(TipAdjustConfirmOK());
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

  Widget ShowTransList(BuildContext context, List<Trans> transList) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return Column(
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
            child: Row(children: [
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Ajuste De Propina',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ]),
          ),
        ]),
        Expanded(
            child: Stack(children: <Widget>[
          Container(
            color: Color(0xFF0D47A1),
          ),
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 1, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Text('Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Spacer(flex: 2),
                            Text('No. Tarjeta', style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(flex: 5),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Spacer(flex: 2),
                            Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(flex: 5),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('Propina', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: new ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: transList.length,
                      controller: ScrollController(),
                      itemBuilder: (context, index) {
                        GlobalKey btnKey = GlobalKey();
                        Trans trans = transList[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Card(
                            elevation: 3,
                            child: InkWell(
                              splashColor: Colors.blueAccent.withAlpha(180),
                              onTap: () {
                                if (trans.tipAdjusted == false) {
                                  final TipAdjustBloc detailReportBloc = BlocProvider.of<TipAdjustBloc>(context);

                                  detailReportBloc.add(TipAdjustAskTip(trans));
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text('Transaccion Ya Fue Ajustada!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                                    duration: Duration(seconds: 1),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(flex: 1),
                                        Text(trans.id.toString(), style: TextStyle(fontWeight: FontWeight.normal)),
                                        Spacer(flex: 6),
                                        SizedBox(
                                          width: 100,
                                          child: Text(trans.maskedPAN,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontFeatures: [FontFeature.tabularFigures()],
                                              )),
                                        ),
                                        Spacer(flex: 2),
                                        SizedBox(
                                          width: 100,
                                          child: Text(formatter.format(trans.baseAmount / 100),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontFeatures: [FontFeature.tabularFigures()],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 90,
                                            child: Text(DateFormat('dd/MM/yyyy').format(trans.dateTime),
                                                textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.normal))),
                                        Spacer(flex: 1),
                                        Text(DateFormat('hh:mm:ss').format(trans.dateTime), style: TextStyle(fontWeight: FontWeight.normal)),
                                        Spacer(flex: 3),
                                        SizedBox(
                                          width: 100,
                                          child: Text(formatter.format(trans.tip / 100),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontFeatures: [FontFeature.tabularFigures()],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 4, 7, 2),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text(formatter.format(trans.total / 100),
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontFeatures: [FontFeature.tabularFigures()],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ))
        ])),
      ],
    );
  }

  Widget TipAdjustMessage(BuildContext context, String message) {
    return Column(children: <Widget>[
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
          child: Row(children: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
                tipAdjustBloc.add(TipAdjustInitialEvent());
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Ajuste De Propina',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ]),
        ),
      ]),
      Expanded(
          child: Stack(children: <Widget>[
        Container(
          color: Color(0xFF0D47A1),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ]))
    ]);
  }

  Widget TipAdjustShowConfirmation(BuildContext context, Trans trans) {
    int amount = trans.baseAmount;
    int tip = trans.tip;
    int total = trans.total;
    String formattedAmount;
    String formattedTip;
    String formattedTotal;
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    formattedAmount = formatter.format(amount / 100).trim();
    formattedTip = formatter.format(tip / 100).trim();
    formattedTotal = formatter.format(total / 100).trim();

    return Column(children: <Widget>[
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
            child: Text(
              'Ajuste De Propina',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
      ]),
      Expanded(
          child: Stack(children: <Widget>[
        Container(
          color: Color(0xFF0D47A1),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(flex: 2),
              RowDetail(label: "Tarjeta:", strAmount: trans.maskedPAN),
              Spacer(flex: 1),
              RowDetail(label: "Cedula:", strAmount: trans.cardholderID),
              Spacer(flex: 1),
              if (trans.binType == Bin.TYPE_FOOD)
                RowDetail(label: "T. Cuenta:", strAmount: 'Alimenticia')
              else if (trans.accType == 0)
                RowDetail(label: "T. Cuenta:", strAmount: 'Credito')
              else if (trans.accType == 2)
                RowDetail(label: "T. Cuenta:", strAmount: 'Corriente')
              else if (trans.accType == 1)
                RowDetail(label: "T. Cuenta:", strAmount: 'Ahorro'),
              Spacer(flex: 1),
              RowDetail(label: "Num. Mesero:", strAmount: trans.server.toString()),
              Spacer(flex: 3),
              RowDetailAmount(label: "Monto:", strAmount: formattedAmount),
              Spacer(flex: 1),
              RowDetailAmount(label: "Propina:", strAmount: formattedTip),
              Spacer(flex: 1),
              Divider(thickness: 4, indent: 30, endIndent: 30),
              Spacer(flex: 1),
              RowDetailAmount(label: "Total:", strAmount: formattedTotal),
              Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnConfirmEnter(context)]),
              ),
            ],
          ),
        ),
      ]))
    ]);
  }

  void onTipClickEnter(BuildContext context, int amount) {
    final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);

    tipAdjustBloc.add(TipAdjustAddTip(amount));
  }

  void onTipClickBack(BuildContext context, Trans trans) {
    final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
    tipAdjustBloc.add(TipAdjustInitialEvent());
  }

  void onClickCancel(BuildContext context) {
    final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
    tipAdjustBloc.add(TipAdjustInitialEvent());
  }

  void onClickRetry(BuildContext context) {
    final TipAdjustBloc tipAdjustBloc = BlocProvider.of<TipAdjustBloc>(context);
    tipAdjustBloc.add(TipAdjustConnect());
  }
}
