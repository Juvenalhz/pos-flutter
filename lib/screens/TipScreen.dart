import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';

import 'amount.dart';

class TipScreen extends StatelessWidget {
  Trans trans;
  final Function(BuildContext, int) onClickEnter;
  final Function(BuildContext, Trans) onClickBack;

  TipScreen(this.trans, this.onClickEnter, this.onClickBack);

  @override
  Widget build(BuildContext context) {
    trans = ModalRoute.of(context).settings.arguments;

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
                        onClickBack(context, trans);
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                        child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
                          if (state is TransactionAddTip) {
                            trans = state.trans;
                            int amount = state.trans.baseAmount;
                            String formattedAmount;
                            var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

                            formattedAmount = formatter.format(amount / 100).trim();

                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Monto:',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                  Text(
                                    formattedAmount,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                ],
                              ),
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                child: AmountEntry('Propina:', onClickEnter),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
