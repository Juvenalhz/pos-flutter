import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/totalsReportBloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/screens/transMessage.dart';
import 'package:pay/utils/spear_menu.dart';

import 'LastSaleDetail.dart';

class TotalsReport extends StatelessWidget {
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
                child: Center(
                    child: BlocListener<TotalsReportBloc, TotalsReportState>(
                  listener: (context, state) {
                    if (state is TotalsReportPrintOk) {
                      if (state.printFromBatch) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: BlocBuilder<TotalsReportBloc, TotalsReportState>(builder: (context, state) {
                    if (state is TotalsReportDataReady) {
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
                            'Reporte De Totales',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 29),
                          ),
                        ),
                        BlocBuilder<TotalsReportBloc, TotalsReportState>(builder: (context, state) {
                          if (state is TotalsReportDataReady) {
                            if (state.totalsData.length > 0)
                              return IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.print_outlined),
                                onPressed: () {
                                  final TotalsReportBloc totalsReportBloc = BlocProvider.of<TotalsReportBloc>(context);

                                  totalsReportBloc.add(TotalsReportPrintReport(context, printFromBatch: false));
                                },
                              );
                            else
                              return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                          } else
                            return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                        }),
                      ]);
                    } else if (state is TotalsReportPrinting) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Cierre De Lote',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 29),
                        ),
                      );
                    } else {
                      return Text('');
                    }
                  }),
                )),
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
                  child: BlocBuilder<TotalsReportBloc, TotalsReportState>(builder: (context, state) {
                    if (state is TotalsReportDataReady) {
                      return Column(
                        children: [
                          SizedBox(height: 25),
                          Expanded(
                            child: ListView.builder(
                              physics: new ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.totalsData.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                GlobalKey btnKey = GlobalKey();
                                Trans trans = new Trans();
                                String acquirer;
                                String acquirerShort;
                                Map<String, dynamic> totals = state.totalsData[index]['totals'];
                                int countTDCOwn = totals['visaCount'] + totals['mastercardCount'] + totals['dinersCount'] + totals['privateCount'];
                                int totalTDCOwn =
                                    totals['visaAmount'] + totals['mastercardAmount'] + totals['dinersAmount'] + totals['privateAmount'];
                                int countTDCOther = totals['visaOtherCount'] +
                                    totals['mastercardOtherCount'] +
                                    totals['dinersOtherCount'] +
                                    totals['privateOtherCount'];
                                int totalTDCOther = totals['visaOtherAmount'] +
                                    totals['mastercardOtherAmount'] +
                                    totals['dinersOtherAmount'] +
                                    totals['privateOtherAmount'];

                                int countTDD = totals['debitCount'] + totals['debitOtherCount'];
                                int totalTDD = totals['debitAmount'] + totals['debitOtherAmount'];
                                int countTDDElectron = totals['electronCount'] + totals['electronOtherCount'];
                                int totalTDDElectron = totals['electronAmount'] + totals['electronOtherAmount'];

                                int totalTCD_TDD = totalTDCOwn + totalTDCOther + totalTDD + totalTDDElectron;

                                if (state.totalsData[index]['acquirer'].toLowerCase().contains('platco')) {
                                  acquirer = 'Platco';
                                  acquirerShort = 'PL';
                                } else if (state.totalsData[index]['acquirer'].toLowerCase().contains('mercantil')) {
                                  acquirer = 'Mercantil';
                                  acquirerShort = 'BM';
                                } else if (state.totalsData[index]['acquirer'].toLowerCase().contains('provincial')) {
                                  acquirer = 'Provincial';
                                  acquirerShort = 'BP';
                                }

                                return Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      Text('ADQUIRIENCIA: ' + state.totalsData[index]['acquirer'],
                                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      Text('TDC ' + acquirer, style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      TotalsDetailLine(totals['visaCount'], 'VISA ' + acquirerShort, totals['visaAmount']),
                                      TotalsDetailLine(totals['mastercardCount'], 'MASTER ' + acquirerShort, totals['mastercardAmount']),
                                      TotalsDetailLine(totals['dinersCount'], 'DINERS ' + acquirerShort, totals['dinersAmount']),
                                      TotalsDetailLine(totals['privateCount'], 'Tarj. PRIV ' + acquirerShort, totals['privateAmount']),
                                      TotalsDetailLine(countTDCOwn, 'Total TDC ' + acquirerShort, totalTDCOwn),
                                      SizedBox(height: 9),
                                      Text('TDC OTROS BANCOS', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      TotalsDetailLine(totals['visaOtherCount'], 'VISA o/Ban', totals['visaOtherAmount']),
                                      TotalsDetailLine(totals['mastercardOtherCount'], 'MASTER  o/Ban', totals['mastercardOtherAmount']),
                                      if (totals['dinersOtherCount'] != 0)
                                        TotalsDetailLine(totals['dinersOtherCount'], 'DINERS  o/Ban', totals['dinersOtherAmount']),
                                      if (totals['privateOtherCount'] != 0)
                                        TotalsDetailLine(totals['privateOtherCount'], 'Tarj. PRIV  o/Ban', totals['privateOtherAmount']),
                                      TotalsDetailLine(countTDCOther, 'Total TDC o/Ban', totalTDCOther),
                                      TotalsLine('Total TDC', totalTDCOwn + totalTDCOther),
                                      SizedBox(height: 9),
                                      Text('TDD', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      TotalsDetailLine(totals['debitCount'], 'Total TDD ' + acquirerShort, totals['debitAmount']),
                                      TotalsDetailLine(totals['debitOtherCount'], 'Total TDD o/Ban', totals['debitOtherAmount']),
                                      SizedBox(height: 9),
                                      Text('TDD VISA ELECTRON', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      TotalsDetailLine(totals['electronCount'], 'Total TVE ' + acquirerShort, totals['electronAmount']),
                                      TotalsDetailLine(totals['electronOtherCount'], 'Total TVE o/Ban', totals['electronOtherAmount']),
                                      TotalsLine('Total TDD', totalTDD + totalTDDElectron),
                                      SizedBox(height: 9),
                                      Text('ALIMENTACIÓN', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 9),
                                      TotalsDetailLine(totals['foodCount'], 'Total TAE ', totals['foodAmount']),
                                      SizedBox(height: 12),
                                      TotalsLine('Total TDC+TDD', totalTCD_TDD),
                                      TotalsLine('Total Cestaticket', totals['foodAmount']),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (state is TotalsReportPrinting) {
                      return TransMessage('Imprimiendo Reporte De Totales');
                    } else
                      return SplashScreen();
                  }))
            ])),
          ],
        ),
      ),
    );
  }

  Widget TotalsDetailLine(int count, String label, int amount) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          SizedBox(
            width: 40,
            child: Text(count.toString().padLeft(4, '0'), textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.normal)),
          ),
          Spacer(flex: 2),
          SizedBox(
            width: 130,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.normal)),
          ),
          Spacer(flex: 6),
          SizedBox(
            width: 100,
            child: Text(formatter.format(amount / 100),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFeatures: [FontFeature.tabularFigures()],
                )),
          ),
        ],
      ),
    );
  }

  Widget TotalsLine(String label, int amount) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Spacer(flex: 6),
          SizedBox(
            width: 100,
            child: Text(formatter.format(amount / 100),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                )),
          ),
        ],
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
          final TotalsReportBloc totalsReportBloc = BlocProvider.of<TotalsReportBloc>(context);

          totalsReportBloc.add(TotalsReportInitialEvent());
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
