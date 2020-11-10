import 'package:flutter/services.dart';

class Printer {
  static const int LEFT = 0;
  static const int CENTER = 1;
  static const int RIGHT = 2;

  static const int FONT_SIZE_SMALL = 0;
  static const int FONT_SIZE_NORMAL = 1;
  static const int FONT_SIZE_LARGE = 2;

  static const MethodChannel _channel = const MethodChannel('printer');

  Printer(){
    _channel.setMethodCallHandler(this._callHandler);
  }

  void addText(int alignMode, String text) async {
    int ret = await _channel.invokeMethod('addText', {'alignMode': alignMode, 'data':text});
  }

  void setFontSize(int fontSize) async {
    int ret = await _channel.invokeMethod('setFontSize', {'fontSize': fontSize});
  }

  void feedLine(int lines) async {
    int ret = await _channel.invokeMethod('feedLine', {'lines': lines});
  }

  void print() async {
    int ret = await _channel.invokeMethod('print');
  }

  Future<dynamic> _callHandler(MethodCall call) async {
    var params = new Map<String, dynamic>();

    if (call.method == 'printDone') {
      // emv tables loaded finished, go to next state
      //transactionBloc.add(TransGetCard());
    } else if (call.method == 'printError') {
      final params = call.arguments;
      //transactionBloc.add(TransShowMessage(getMessage(params['id'], params['msg'])));
    }
  }

}