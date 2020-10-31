import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/TransStatusScreen.dart';
import 'package:pay/screens/Confirmation.dart';
import 'package:pay/screens/AskNumeric.dart';
import 'package:pay/screens/selectionMenu.dart';
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
    bool pinpadInit = false;

    return Container(
      child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
        if (pinpadInit == false) {
          transactionBloc.add(TransInitPinpad(pinpad));
          pinpadInit = true;
        }

        if (state is TransactionAddAmount) {
          return (MainScreen());
        } else if (state is TransactionAddTip) {
          return TipScreen(state.trans);
        } else if (state is TransactionAskIdNumber) {
          return new AskID('Numero', 'De Cedula', '', 6, 9, AskNumeric.NO_DECIMALS, onClickIDEnter, onClickIDBack);
        } else if (state is TransactionAskLast4Digits) {
          return new AskLast4('Ingrese', 'Ultimos 4 Digitos', '', 4, 4, AskNumeric.NO_SEPARATORS, onClickLast4Enter, onClickLast4Back);
        } else if (state is TransactionAskCVV) {
          return new AskCVV('Ingrese Codigo', 'De Seguridad', '', 3, 4, AskNumeric.NO_SEPARATORS, onClickCVVEnter, onClickCVVBack);
        } else if (state is TransactionAskConfirmation) {
          return Confirmation(trans: state.trans);
        } else if (state is TransactionAskAccountType) {
          LinkedHashMap<int, String> accTypes = LinkedHashMap.from({0: 'Cuenta Corriente', 1: 'Ahorro'});
          return SelectionMenu("Seleccione Tipo de Cuenta", accTypes, false, onSelection: onAccTypeSelection);
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
        } else if (state is TransactionConnecting) {
          return CommProgress('Autorización', status: 'Conectando').build(context);
        } else if (state is TransactionSending) {
          return CommProgress('Autorización', status: 'Enviando').build(context);
        } else if (state is TransactionReceiving) {
          return CommProgress('Autorización', status: 'Recibiendo').build(context);
        } else if (state is TransactionCompleted) {
          //transactionBloc.add(TransStartTransaction());
          return TransStatusScreen(state.trans);
        } else if (state is TransactionError) {
          transactionBloc.add(TransStartTransaction());
          return TransMessage("Transacción Cancelada");
        } else
          //TODO: change the default screen to something valid
          return TransMessage('procesessing!!');
      }),
    );
  }

  void onClickLast4Enter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddLast4(value));
  }

  void onClickLast4Back(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransLast4Back());
  }

  void onClickIDEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddIdNumber(value));
  }

  void onClickIDBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransIDBack());
  }

  void onClickCVVEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddCVV(value));
  }

  void onClickCVVBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCVVBack());
  }

  void onAccTypeSelection(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (value == 0)
      transactionBloc.add(TransAddAccountType(2)); // checking account
    else if (value == 1) transactionBloc.add(TransAddAccountType(1)); // saving account
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
            SizedBox(height: 90),
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
            SizedBox(height: 70),
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
