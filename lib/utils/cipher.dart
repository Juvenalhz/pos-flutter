import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pay/utils/serialNumber.dart';

class Cipher {
  static const MethodChannel _channel = const MethodChannel('cipher');

  Future<String> encryptCriticalData(String data) async {
    return await _channel.invokeMethod('cipherCriticalData', {'data':data});
  }

  Future<String> decryptCriticalData(String data) async {
    return await _channel.invokeMethod('decipherCriticalData', {'data':data});
  }

  Future<Uint8List> cipherMessage(Uint8List data, int kin) async {

    Uint8List cipheredData = await _channel.invokeMethod('cipherMessage', {'data': data, 'keyId': kin});
    return cipheredData;

  }
}
