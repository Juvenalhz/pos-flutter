import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/emvCallbacks.dart';
import 'TipScreen.dart';
import 'commProgress.dart';
import 'mainScreen.dart';

class Transaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);


    return Container(
      child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
        if (state is TransactionAddAmount) {
          return (MainScreen());
        } else if (state is TransactionAddTip) {
          return TipScreen(state.trans);
          // steps of the transaction flow
          transactionBloc.add(TransLoadEmvTables());
        } else if (state is TransactionLoadEmvTable) {
          //transactionBloc.add(TransLoadEmvTables());
          return SplashScreen();
        }else if (state is TransactionWaitEmvTablesLoaded){
          return CommProgress('Espere, por favor', status: 'Configrando tablas EMV...').build(context);
        } else
          //TODO: change the default screen to something valid
          return SplashScreen();
      }),
    );
  }
}
