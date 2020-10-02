import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/screens/selectionMenu.dart';
import 'package:pay/screens/transMessage.dart';

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

  void goOnChip(Map<String, dynamic> trans, Map<String, dynamic> terminal, Map<String, dynamic> aid) async {
    await _channel.invokeMethod('goOnChip', {'trans': trans, 'keyIndex': terminal['keyIndex'], 'aid': aid});
  }

  Pinpad(this.context) {
    _channel.setMethodCallHandler(this._callHandler);
    transactionBloc = BlocProvider.of<TransactionBloc>(this.context);
  }

  Future<dynamic> _callHandler(MethodCall call) async {
    if (call.method == 'tablesLoaded') {
      // emv tables loaded finished, go to next state
      transactionBloc.add(TransGetCard());
    } else if (call.method == 'showMessage') {
      final params = call.arguments;
      transactionBloc.add(TransShowMessage(getMessage(params['id'], params['msg'])));
    } else if (call.method == 'cardRead') {
      var params = new Map<String, dynamic>();

      call.arguments.forEach((key, value) {
        params[key] = value;
      });
      // card read successfully
      transactionBloc.add(TransCardWasRead(params));
    } else if (call.method == 'showMenu') {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionMenu('Seleccionar Aplication:', call.arguments)));
      return result;
    }
    return 0;
  }

  String getMessage(int id, String s) {
    const int TEXT_S = 0;
    const int PROCESSING = 1;
    const int INSERT_SWIPE_CARD = 2;
    const int TAP_INSERT_SWIPE_CARD = 3;
    const int SELECT = 4;
    const int SELECTED_S = 5;
    const int INVALID_APP = 6;
    const int WRONG_PIN_S = 7;
    const int PIN_LAST_TRY = 8;
    const int PIN_BLOCKED = 9;
    const int PIN_VERIFIED = 10;
    const int CARD_BLOCKED = 11;
    const int REMOVE_CARD = 12;
    const int UPDATING_TABLES = 13;
    const int UPDATING_RECORD = 14;
    const int PIN_STARTING = 15;
    const int SECOND_TAP = 16;

    switch (id) {
      case TEXT_S:
        return s;
      case PROCESSING:
        return "Procesando...";
      case INSERT_SWIPE_CARD:
        return "Inserte o Deslice Tarjeta";
      case TAP_INSERT_SWIPE_CARD:
        return "Acerque, Inserte o Deslice Tarjeta";
      case SELECT:
        return "Seleccione";
      case SELECTED_S:
        return "Seleccion: " + s;
      case INVALID_APP:
        return "Aplicacion Invalida";
      case WRONG_PIN_S:
        return "Clave invalida (" + s + " intentos restantes)";
      case PIN_LAST_TRY:
        return "Ultimo Intengo de Increso de Clave!";
      case PIN_BLOCKED:
        return "Clave Bloqueada!";
      case CARD_BLOCKED:
        return "Tarjeta Bloqueada!";
      case REMOVE_CARD:
        return "Remueva Tarjeta";
      case UPDATING_TABLES:
        return "Actualizando Tablas EMV...";
      case SECOND_TAP:
        return "Acerque la Tarjeta Nuevamente";
      case PIN_VERIFIED:
      case UPDATING_RECORD:
      case PIN_STARTING:
      default:
        return "";
    }
  }
}
