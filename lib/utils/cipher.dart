import 'package:flutter/services.dart';

class Cipher {
  static const MethodChannel _channel = const MethodChannel('cipher');

  Future<String> encryptCriticalData(String data) async {
    return await _channel.invokeMethod('cipherCriticalData', {'data':data});
  }

  Future<String> decryptCriticalData(String data) async {
    return await _channel.invokeMethod('decipherCriticalData', {'data':data});
  }
}