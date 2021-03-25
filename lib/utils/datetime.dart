
import 'package:flutter/services.dart';

class SetDateTime {
  static const MethodChannel _channel = const MethodChannel('Date_Time');

  set dateTime(String dateTime) {
    _channel.invokeMethod('setDateTime', {'datetime': dateTime});
  }
}
