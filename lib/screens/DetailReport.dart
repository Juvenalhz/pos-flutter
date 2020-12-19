import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/splash.dart';

class DetailReport extends StatelessWidget {

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
                child: Center(
                    child: Row(children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Reporte Detallado',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.print_outlined),
                    onPressed: () {},
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
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                  child: BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                    if (state is DetailReportDataReady) {
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
                                      Spacer(flex: 3),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                        child: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Spacer(flex: 3),
                                      Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Spacer(flex: 3),
                                      Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Spacer(flex: 4),
                                      Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Spacer(flex: 5),

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
                                  Trans trans = Trans.fromMap(state.transList[index]);
                                  return Card(
                                    elevation: 3,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.blueAccent.withAlpha(180),
                                                child: Icon(Icons.list),
                                                onTap: () {
                                                  print('tap $index');
                                                },
                                              ),
                                              Spacer(flex: 1),
                                              Text(trans.id.toString(), style: TextStyle(fontWeight: FontWeight.normal)),
                                              Spacer(flex: 6),
                                              SizedBox(
                                                width: 100,
                                                child: Text(trans.maskedPAN, textAlign: TextAlign.left, style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFeatures: [
                                                    FontFeature.tabularFigures()
                                                  ],
                                                )),
                                              ),
                                              Spacer(flex: 2),
                                              SizedBox(
                                                width: 100,
                                                child: Text(formatter.format(trans.total / 100),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontFeatures: [
                                                        FontFeature.tabularFigures()
                                                      ],
                                                    )
                                                ),
                                              ),



                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                                          child: Row(
                                            children: [
                                              Spacer(flex: 2),
                                              Text(trans.type, style: TextStyle(fontWeight: FontWeight.normal)),
                                              Spacer(flex: 2),
                                              Text(DateFormat('dd/MM/yyyy').format(trans.dateTime), style: TextStyle(fontWeight: FontWeight.normal)),
                                              Spacer(flex: 2),
                                              Text(DateFormat('hh:mm:ss').format(trans.dateTime), style: TextStyle(fontWeight: FontWeight.normal)),
                                              Spacer(flex: 4),
                                            ],
                                          ),
                                        ),
                                      ],
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
        onPressed: () {},
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


