import 'dart:async';
import 'package:flutter/services.dart';

class Pinpad {
  static const MethodChannel _channel = const MethodChannel('pinpad');

  void loadTables(Map<String, dynamic> emv, List<Map<String, dynamic>> aids, List<Map<String, dynamic>> pubKeys) async {
    await _channel.invokeMethod('loadTables', {'emv': emv, 'aids': aids, 'pubKeys': pubKeys});
  }
}
