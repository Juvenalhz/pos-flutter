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
    setFontSize(FONT_SIZE_NORMAL);
  }

  void addText(int alignMode, String text) async {
    int ret = await _channel.invokeMethod('addText', {'alignMode': alignMode, 'data': text});
  }

  void addTextSideBySide(String left, String right) async {
    String text;
    int lineSize;

    if (currentSize == FONT_SIZE_SMALL)
      lineSize = 48;
    else
      lineSize = 32;

    text = left.padRight(lineSize ~/ 2, ' ').substring(0, lineSize ~/ 2);
    text += right.padLeft(lineSize ~/ 2, ' ').substring(0, lineSize ~/ 2);

    int ret = await _channel.invokeMethod('addText', {'alignMode': LEFT, 'data': text});
  }

  void addTextSideBySideWithCenter(String left, String center, String right) async {
    String text;
    int lineSize;
    int padCenter;
    int part;

    if (currentSize == FONT_SIZE_SMALL)
      lineSize = 48;
    else
      lineSize = 32;

    part = lineSize ~/ 3;
    padCenter = center.length + ((part - center.length) ~/ 2);

    text = left.padRight((lineSize ~/ 3), ' ').substring(0, (lineSize ~/ 3));
    text += center.padLeft(padCenter, ' ').padRight((lineSize ~/ 3), ' ').substring(0, lineSize ~/ 3);
    text += right.padLeft((lineSize ~/ 3), ' ').substring(0, (lineSize ~/ 3));

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
    addText(LEFT, ''.padRight((currentSize == FONT_SIZE_SMALL) ? 48 : 32, c[0].toString()));
  }
}
