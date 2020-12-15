import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/splash.dart';

class DetailReport extends StatelessWidget {
  DetailReport();

  @override
  Widget build(BuildContext context) {
    int total = 0;
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
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {},
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                  child: BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                    if (state is DetailReportDataReady) {
                      return ListView.builder(
                        itemCount: state.transList.length,
                        itemBuilder: (context, index) {
                          formattedTotal = formatter.format(state.transList[index]['total'] / 100).trim();
                          return ListTile(
                            title: Text('${formattedTotal}'),
                          );
                        },
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
