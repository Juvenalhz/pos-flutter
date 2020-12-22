import 'package:flutter/services.dart';

class Printer {
  static const int LEFT = 0;
  static const int CENTER = 1;
  static const int RIGHT = 2;

  static const int FONT_SIZE_SMALL = 0;
  static const int FONT_SIZE_NORMAL = 1;
  static const int FONT_SIZE_LARGE = 2;

  static const MethodChannel _channel = const MethodChannel('printer');
  Function() onPrintFinish;
  Function(int) onPrintError;
  int currentSize;

  Printer() {
    _channel.setMethodCallHandler(this._callHandler);
    currentSize = FONT_SIZE_NORMAL;
  }

  void addText(int alignMode, String text) async {
    int ret = await _channel.invokeMethod('addText', {'alignMode': alignMode, 'data': text});
  }

  void addTextSideBySide(String left, String right) async {
    String text;
    int lineSize;

    if (currentSize == FONT_SIZE_SMALL)
      lineSize = 50;
    else
      lineSize = 32;

    text = left.padRight(lineSize ~/ 2, ' ').substring(0, lineSize ~/ 2);
    text += right.padLeft(lineSize ~/ 2, ' ').substring(0, lineSize ~/ 2);

    int ret = await _channel.invokeMethod('addText', {'alignMode': RIGHT, 'data': text});
  }

  void addTextSideBySideWithCenter(String left, String center, String right) async {
    String text;
    int lineSize;

    if (currentSize == FONT_SIZE_SMALL)
      lineSize = 50;
    else
      lineSize = 32;

    text = left.padRight(lineSize ~/ 4, ' ').substring(0, lineSize ~/ 4);
    text += center.padRight(lineSize ~/ 4, ' ').substring(0, lineSize ~/ 4);
    text += right.padLeft(lineSize ~/ 4, ' ').substring(0, lineSize ~/ 4);

    int ret = await _channel.invokeMethod('addText', {'alignMode': CENTER, 'data': text});
  }

  void setFontSize(int fontSize) async {
    currentSize = fontSize;
    int ret = await _channel.invokeMethod('setFontSize', {'fontSize': fontSize});
  }

  void feedLine(int lines) async {
    int ret = await _channel.invokeMethod('feedLine', {'lines': lines});
  }

  void print(Function onPrintFinish, Function onPrintError) async {
    this.onPrintFinish = onPrintFinish;
    this.onPrintError = onPrintError;

    int ret = await _channel.invokeMethod('print');
  }

  Future<dynamic> _callHandler(MethodCall call) async {
    var params = new Map<String, dynamic>();

    if (call.method == 'printDone') {
      this.onPrintFinish();
    } else if (call.method == 'printError') {
      final params = call.arguments;
      this.onPrintError(params['error']);
    }
  }

  addTextFillLine(String c) {
    addText(LEFT, ''.padRight((currentSize == FONT_SIZE_SMALL) ? 50 : 32, c[0].toString()));
  }
}
