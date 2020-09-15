import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';

import 'amount.dart';

class TipScreen extends StatelessWidget {
  Trans trans;

  TipScreen(this.trans);
  @override
  Widget build(BuildContext context) {
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
                child: Stack(children: <Widget>[
                  Positioned(
                    left: 6,
                    top: 6,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                        child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
                          if (state is TransactionAddTip) {
                            int amount = state.trans.baseAmount;
                            return Text(
                              'Monto: $amount',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            );
                          } else {
                            return Text(
                              'Propina',
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                child: AmountEntry('Propina:', trans),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
