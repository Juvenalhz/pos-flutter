import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/Confirmation.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/screens/transMessage.dart';
import 'package:pay/utils/pinpad.dart';
import 'TipScreen.dart';
import 'commProgress.dart';
import 'mainScreen.dart';

class Transaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    Pinpad pinpad = new Pinpad(context);

    return Container(
      child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
        if (state is TransactionAddAmount) {
          return (MainScreen());
        } else if (state is TransactionAddTip) {
          return TipScreen(state.trans);
        } else if (state is TransactionAskConfirmation) {
          return Confirmation(trans: state.trans, pinpad: pinpad);
        } else if (state is TransactionLoadEmvTable) {
          //transactionBloc.add(TransLoadEmvTables());
          print('show splash screen');
          return SplashScreen();
        } else if (state is TransactionWaitEmvTablesLoaded) {
          return TransMessage('Espere, por favor');
        } else if (state is TransactionShowMessage) {
          return TransMessage(state.message);
        } else if (state is TransactionCardRead) {
          // TODO: add
          return TransMessage(state.trans.appLabel);
        } else if (state is TransactionShowPinAmount) {
          return PinEntryMessage(state.trans);
        } else if (state is TransactionCompleted) {
          transactionBloc.add(TransStartTransaction());
          return TransMessage("Transacción Completada");
        } else
          //TODO: change the default screen to something valid
          return TransMessage('procesessing!!');
      }),
    );
  }
}

class PinEntryMessage extends StatelessWidget {
  final Trans trans;

  PinEntryMessage(this.trans);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return Material(
      child: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Text(
                'Ingrese PIN:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 130),
            Center(
              child: Text(
                this.trans.type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                formatter.format(this.trans.total / 100),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
