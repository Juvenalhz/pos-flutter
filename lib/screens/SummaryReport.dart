import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/summaryReportBloc.dart';
import 'package:pay/screens/splash.dart';

class SummaryReport extends StatelessWidget {
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
                child: Center(child: BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                  if (state is SummaryReportDataReady) {
                    return Row(children: [
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              'Resumen',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              'De Parámetros',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                        if (state is SummaryReportDataReady) {
                          if (state.merchant != null)
                            return IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.print_outlined),
                              onPressed: () {
                                final SummaryReportBloc detailReportBloc = BlocProvider.of<SummaryReportBloc>(context);

                                detailReportBloc.add(SummaryReportPrintReport(context));
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
                  child: BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                    if (state is SummaryReportDataReady) {
                      return Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: ListView(
                          children: [
                            Text('line 1'),
                            Text('line 2'),
                          ],
                        ),
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
