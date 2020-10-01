import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
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
          // steps of the transaction flow
          transactionBloc.add(TransLoadEmvTables(pinpad));
          return TipScreen(state.trans);
        } else if (state is TransactionLoadEmvTable) {
          //transactionBloc.add(TransLoadEmvTables());
          return SplashScreen();
        } else if (state is TransactionWaitEmvTablesLoaded) {
          return TransMessage('Espere, por favor');
        } else if (state is TransactionShowMessage) {
          return TransMessage(state.message);
        } else if (state is TransactionCardRead){
          // TODO: add
          return TransMessage(state.trans.appLabel);
        }
        else
          //TODO: change the default screen to something valid
          return SplashScreen();
      }),
    );
  }
}
