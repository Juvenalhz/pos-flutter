import 'dart:typed_data';

import 'package:convert/convert.dart';

void memDump(String title, Uint8List data) {
  int i = 0;
  String temp = '';

  print(title);
  for (i = 0; i < data.length; i++) {
    temp += hex.encode(data.sublist(i, i + 1)).toString() + ' ';
    if ((i != 0) && (i % 32) == 0) {
      if (temp.length > 0) {
        print(temp);
        temp = '';
      }
    }
  }
  if (i == data.length) print(temp);
}

String bcdToStr(Uint8List data) {
  return hex.encode(data);
}

Uint8List strToBcd(String data) {
  if (data.length != 0) {
    if (data.length % 2 == 1) {
      String temp = data.padLeft(data.length + 1, '0');
      return new Uint8List.fromList(hex.decode(temp));
    }
    return new Uint8List.fromList(hex.decode(data));
  }
  return null;
}

int bcd2Int(Uint8List bcd, int len) {
  if ((len > 0) && (len < 9))
    return int.parse(bcdToStr(bcd.sublist(0, len)), radix: 16).toUnsigned(64);
  else
    throw 'Invalid length';
}

Uint8List int2Bcd(int i, [int size]) {
  String temp = i.toRadixString(16).toString();

  if ((size == null) || (size == 0)) {
    if (temp.length % 2 == 1) {
      temp = temp.padLeft(temp.length + 1, '0');
    }
  } else {
    temp = temp.padLeft(size * 2, '0');
  }

  return strToBcd(temp);
}