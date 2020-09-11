import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'amount.dart';

class TipScreen extends StatelessWidget {
  var trans = new Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    trans = ModalRoute.of(context).settings.arguments;

    return Scaffold(
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
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                child: Text(
                  'Propina',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
              )),
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
              child: AmountEntry('Propina:', trans),
            ),
          ])),
        ],
      ),
    );
  }
}
