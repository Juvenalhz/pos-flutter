
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';

class EmvCallbacks {
  BuildContext context;
  static const MethodChannel _channel = const MethodChannel('com.lccnet.pay/emvCallbacks');

  EmvCallbacks(this.context) {
    _channel.setMethodCallHandler(this._callHandler);
  }

  Future<dynamic> _callHandler(MethodCall call) async {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    final String utterance = call.arguments;

    switch (call.method) {
      case "tablesLoaded":
        // emv tables loaded finished, go to next state
        transactionBloc.add(TransGetCard());
        return 0;
        break;
      case "cardRead":
        // card read succesfully
        break;
    }
  }

}