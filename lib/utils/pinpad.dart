import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transactionBloc.dart';

class Pinpad {
  final BuildContext context;
  static const MethodChannel _channel = const MethodChannel('pinpad');
  TransactionBloc transactionBloc;

  void loadTables(Map<String, dynamic> emv, List<Map<String, dynamic>> aids, List<Map<String, dynamic>> pubKeys) async {
    await _channel.invokeMethod('loadTables', {'emv': emv, 'aids': aids, 'pubKeys': pubKeys});
  }

  void getCard(Map<String, dynamic> trans) async {
    await _channel.invokeMethod('getCard', {'trans': trans});
  }

  Pinpad(this.context) {
    _channel.setMethodCallHandler(this._callHandler);
    transactionBloc = BlocProvider.of<TransactionBloc>(this.context);
  }

  Future<dynamic> _callHandler(MethodCall call) async {
    final String utterance = call.arguments;

    switch (call.method) {
      case "tablesLoaded":
        // emv tables loaded finished, go to next state
        transactionBloc.add(TransGetCard());
        return 0;
        break;
      case "cardRead":
      // card read succesfully
        transactionBloc.add(TransGetCard());
        break;
    }
  }

}
