import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/bloc/tipReportBloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/utils/spear_menu.dart';

import 'LastSaleDetail.dart';

class TipReport extends StatelessWidget {
  final List<String> menuListWithVoid = new List<String>.of(['Ver Detalles', 'Copia del Comercio', 'Copia del Cliente', 'Anulación']);
  final List<String> menuList = new List<String>.of(['Ver Detalles', 'Copia del Comercio', 'Copia del Cliente']);

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
                child: Center(child: BlocBuilder<TipReportBloc, TipReportState>(builder: (context, state) {
                  if (state is TipReportDataReady) {
                    return Row(children: [
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
                          'Resumen De Propina',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
                        ),
                      ),
                      BlocBuilder<TipReportBloc, TipReportState>(builder: (context, state) {
                        if (state is TipReportDataReady) {
                          if (state.transList.length > 0)
                            return IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.print_outlined),
                              onPressed: () {
                                final TipReportBloc detailReportBloc = BlocProvider.of<TipReportBloc>(context);

                                detailReportBloc.add(TipReportPrintReport(context));
                              },
                            );
                          else
                            return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                        } else
                          return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                      }),
                    ]);
                  } else {
                    return Text('');
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
                  child: BlocBuilder<TipReportBloc, TipReportState>(builder: (context, state) {
                    if (state is TipReportDataReady) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: new ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.transList.length + 1,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                if (index < state.transList.length)
                                  if (state.transList[index]['total'] > 0)
                                    return Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Text('ADQUIRIENCIA: ' + state.transList[index]['acquirer'],
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                fontFeatures: [FontFeature.tabularFigures()],
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 12, 1, 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                  child: Text('Num', style: TextStyle(fontWeight: FontWeight.bold)),
                                                ),
                                                Spacer(flex: 2),
                                                Text('Mesero', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Spacer(flex: 4),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                                  child: Text('Propina', style: TextStyle(fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: state.transList[index]['tips'].length,
                                              itemBuilder: (context, i) {
                                                Map<String, dynamic> tips = state.transList[index]['tips'][i];
                                                return Card(
                                                    elevation: 3,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
                                                      child: Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Spacer(flex: 2),
                                                          Text(tips['count'].toString(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                                                          Spacer(flex: 7),
                                                          SizedBox(
                                                            width: 30,
                                                            child: Text(tips['server'].toString(),
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontFeatures: [FontFeature.tabularFigures()],
                                                                )),
                                                          ),
                                                          Spacer(flex: 6),
                                                          SizedBox(
                                                            width: 100,
                                                            child: Text(formatter.format(tips['total'] / 100),
                                                                textAlign: TextAlign.right,
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontFeatures: [FontFeature.tabularFigures()],
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                              }),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 13, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Total Propinas:',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      fontFeatures: [FontFeature.tabularFigures()],
                                                    )),
                                                Text(formatter.format(state.transList[index]['total'] / 100),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                      fontFeatures: [FontFeature.tabularFigures()],
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  else
                                    return Container();
                                else
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 0, 15, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total Gral. Propinas:',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFeatures: [FontFeature.tabularFigures()],
                                                )),
                                            Text(formatter.format(state.tipGrandTotal / 100),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFeatures: [FontFeature.tabularFigures()],
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
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
}
