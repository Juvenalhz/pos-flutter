import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/tipAdjustBloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/utils/spear_menu.dart';

import 'LastSaleDetail.dart';

class TipAdjust extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

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
                child: Center(child: BlocBuilder<TipAdjustBloc, TipAdjustState>(builder: (context, state) {
                  if (state is TipAdjustDataReady) {
                    return Row(children: [
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
                    ]);
                  } else {
                    return Container();
                  }
                })),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                  child: BlocBuilder<TipAdjustBloc, TipAdjustState>(builder: (context, state) {
                    if (state is TipAdjustDataReady) {
                      return Column(
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
                              itemCount: state.transList.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                GlobalKey btnKey = GlobalKey();
                                Trans trans = state.transList[index];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  child: Card(
                                    elevation: 3,
                                    child: InkWell(
                                      splashColor: Colors.blueAccent.withAlpha(180),
                                      onTap: () {},
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
                      );
                    } else
                      return SplashScreen();
                  }))
            ])),
          ],
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context, bool approved) {
    Color btnColor = (approved) ? Colors.green : Colors.red;
    IconData btnIcon = (approved) ? Icons.done_outline : Icons.error_outline;

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(btnIcon, size: 35, color: Colors.white),
        onPressed: () {
          final TipAdjustBloc detailReportBloc = BlocProvider.of<TipAdjustBloc>(context);

          detailReportBloc.add(TipAdjustInitialEvent());
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
