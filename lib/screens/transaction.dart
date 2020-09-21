import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/screens/Confirmation.dart';
import 'package:pay/screens/splash.dart';
import 'TipScreen.dart';
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
        } else if (state is TransactionAskConfirmation) {
          return Confirmation(trans: state.trans);

          // steps of the transaction flow

        } else
          //TODO: change the default screen to something valid
          return Scaffold();
      }),
    );
  }
}
