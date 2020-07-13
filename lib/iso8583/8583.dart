import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'dart:typed_data';
import 'package:convert/convert.dart';

import '8583specs.dart';

enum DT {
  BCD,
  ASCII,
  BIN,
}

enum LT {
  FIXED,
  LVAR,
  LLVAR,
  LLLVAR,
}

enum ISOSPEC {
  ISO_1987,
  ISO_ASCII,
  ISO_BCD,
}

void memDump(String title, Uint8List data) {
  int i = 0;
  String temp = '';

  print(title);
  for (i = 0; i < data.length; i++) {
    temp += hex.encode(data.sublist(i, i + 1)).toString() + ' ';
    if ((i % 32) == 0) {
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
    return int.parse(bcdToStr(bcd.sublist(0, len)), radix: 16);
  else
    throw 'Invalid length';
}

Uint8List int2Bcd(int i) {
  String temp = i.toRadixString(16).toString();
  if (temp.length % 2 == 1) {
    temp = temp.padLeft(temp.length + 1, '0');
  }
  return strToBcd(temp);
}

class Iso8583 {
  //List<String> validContentTypes = new List.unmodifiable(['a', 'n', 's', 'an', 'as', 'ns', 'ans', 'b', 'z']);
  bool _strict;
  //int _index;
  Uint8List _isoMsg;
  var _isoSpec;
  Uint8List _Bitmap = new Uint8List(128);
  int _MID;
  List<Map<String, dynamic>> _data;

  Iso8583([Uint8List isoMsg, ISOSPEC isoSpec]) {
    if (isoSpec == null) {
      this._isoSpec = new IsoSpecASCII();
    } else {
      if (isoSpec == ISOSPEC.ISO_1987)
        this._isoSpec = new IsoSpec1987();
      else if (isoSpec == ISOSPEC.ISO_ASCII)
        this._isoSpec = new IsoSpecASCII();
      else if (isoSpec == ISOSPEC.ISO_BCD)
        this._isoSpec = new IsoSpecBCD();
      else
        throw 'Wrong ISO type';
    }

    this._data = new List();
    this._strict = false;

    if (isoMsg == null) {
      this._isoMsg = new Uint8List(2000);
    } else {
      this._isoMsg = isoMsg;
      parseIso();
    }
  }

  void setStrict(bool value) {
    this._strict = value;
  }

  void setIsoContect(Uint8List isoMsg) {
    this._isoMsg = isoMsg;
    parseIso();
  }

  int parseMID(Uint8List p, int index) {
    DT dataType = this._isoSpec.dataType(MID);

    if (dataType == DT.BCD) {
      this._MID = int.parse(bcdToStr(this._isoMsg.sublist(index, index + 2)));
      index += 2;
    } else if (dataType == DT.ASCII) {
      this._MID = int.parse(this._isoMsg.sublist(index, index + 4).toString());
      index += 4;
    }

    return index;
  }

  int parseBitmap(int index) {
    DT dataType = _isoSpec.dataType(1);
    Uint8List bitmapBuffer;
    int intBitmap;

    if (dataType == DT.BCD) {
      bitmapBuffer = _isoMsg.sublist(index, index + 8);
      index += 8;
    } else if (dataType == DT.ASCII) {
      bitmapBuffer = strToBcd(_isoMsg.sublist(index, index + 16).toString());
      index += 16;
    }

    intBitmap = bcd2Int(bitmapBuffer, 8);
    for (var i = 0; i < 65; i++) {
      _Bitmap[i] = intBitmap >> (64 - i) & 1;
    }

    if (_Bitmap[1] == 1) {
      //secundary bitmap
      if (dataType == DT.BIN) {
        bitmapBuffer = _isoMsg.sublist(index, index + 8);
        index += 8;
      } else if (dataType == DT.ASCII) {
        bitmapBuffer = strToBcd(_isoMsg.sublist(index, index + 16).toString());
        index += 16;
      }
      intBitmap = bcd2Int(bitmapBuffer, 8);
      for (var i = 0; i < 65; i++) {
        _Bitmap[i + 64] = intBitmap >> (64 - i) & 1;
      }
    }
    return index;
  }

  int parseField(int field, int index) {
    var dataType;
    var contentType;
    var maxLength;
    int len;
    DT lenDataType;
    LT lenType;
    Map<String, dynamic> fieldData = new Map();

    //print('ParseField ' + field.toString());

    if (field == 55) {
      field += 0;
    }

    dataType = _isoSpec.dataType(field);
    lenType = _isoSpec.lengthType(field);
    contentType = _isoSpec.contentType(field);
    maxLength = _isoSpec.maxLength(field);

    if ((dataType == DT.ASCII) && (contentType == 'b')) {
      maxLength *= 2;
    }

    if (lenType == LT.FIXED)
      len = maxLength;
    else if (lenType == LT.LLVAR) {
      lenDataType = _isoSpec.lengthDataType(field);
      if (lenDataType == DT.ASCII) {
        len = bcd2Int(_isoMsg.sublist(index, index + 2), 2);
        index += 2;
      } else if (lenDataType == DT.BCD) {
        String temp = bcdToStr(_isoMsg.sublist(index, index + 1));
        len = int.parse(temp);
        index += 1;
      } else if (lenDataType == DT.BIN) {
        len = _isoMsg[index];
        index += 1;
      }
    } else if (lenType == LT.LLLVAR) {
      lenDataType = _isoSpec.lengthDataType(field);
      if (lenDataType == DT.ASCII) {
        len = bcd2Int(_isoMsg.sublist(index, index + 4), 4);
        index += 4;
      } else if (lenDataType == DT.BCD) {
        String temp = bcdToStr(_isoMsg.sublist(index, index + 2));
        len = int.parse(temp);
        index += 2;
      } else if (lenDataType == DT.BIN) {
        len = _isoMsg[index]; //TODO fix this legnth as it needs 2 bytes
        index += 2;
      }
    }
    if (len > maxLength) throw "Flield $field is larger than maximum length $len > $maxLength";

    //this._isoSpec.length(field, len);

    if (len == 0) return index; // In case of zero length, don't try to parse the field itself, just continue

    if (dataType == DT.ASCII) {
      if (contentType == 'n') {
        fieldData['field'] = field;
        fieldData['data'] = _isoMsg.sublist(index, index + len);
      } else {
        fieldData['field'] = field;
        fieldData['data'] = AsciiDecoder().convert(_isoMsg.sublist(index, index + len));
      }
      index += len;
    } else if (dataType == DT.BCD) {
      if (len % 2 == 1) len += 1;
      if (contentType == 'n') {
        fieldData['field'] = field;
        fieldData['data'] = bcdToStr(_isoMsg.sublist(index, index + (len ~/ 2)));
      } else if (contentType == 'z') {
        fieldData['field'] = field;
        fieldData['data'] = bcdToStr(_isoMsg.sublist(index, index + (len ~/ 2))).toUpperCase();
      }
      index += len ~/ 2;
    } else if (dataType == DT.BIN) {
      fieldData['field'] = field;
      fieldData['data'] = hex.encode(_isoMsg.sublist(index, index + len)).toString().toUpperCase();
      index += len;
    }

    if (contentType == 'z') {
      fieldData['data'] = fieldData['data'].replaceAll('D', '=');
      fieldData['data'] = fieldData['data'].replaceAll('F', '');
    }

    this._data.add(fieldData);

    //print('Field[$field]: ' + fieldData['data']);
    return index;
  }

  void parseIso() {
    int index = 0;
    int i = 0;
    _data.removeRange(0, _data.length);

    index = parseMID(_isoMsg, index);
    index = parseBitmap(index);

    for (i = 0; i < 128; i++) {
      if (_Bitmap[i] == 1) {
        index = parseField(i, index);
      }
    }
  }

  int buildMID(int index) {
    if (_isoSpec.dataType(MID) == DT.BCD) {
      Uint8List temp = strToBcd(_MID.toString().padLeft(4, '0'));

      temp.forEach((element) {
        this._isoMsg[index++] = element;
      });
      return index;
    } else if (_isoSpec.dataType(MID) == DT.ASCII) {
      this._isoMsg = this._isoMsg + AsciiEncoder().convert(_MID.toString().padLeft(4, '0'));
    }
  }

  int buildBitmap(int index) {
    int intBitmap = 0;
    bool hassecondary = false;
    DT dataType = _isoSpec.dataType(1);
    int i;

    //primary bitmap
    for (i = 0; i < 65; i++) {
      if (this._Bitmap[i] == 1) {
        intBitmap |= (1 << (64 - i)).toUnsigned(64);
      }
    }

    if (dataType == DT.ASCII) {
      Uint8List temp = AsciiEncoder().convert(intBitmap.toRadixString(16).toString());
      temp.forEach((element) {
        this._isoMsg[index++] = element;
      });
    } else if ((dataType == DT.BIN) || (dataType == DT.BCD)) {
      Uint8List temp = int2Bcd(intBitmap);

      temp.forEach((element) {
        this._isoMsg[index++] = element;
      });
    }

    //secondary bitmap
    intBitmap = 0;
    for (var i = 65; i < 128; i++) {
      if (_Bitmap[i] == 1) {
        intBitmap |= (1 << 128 - i).toUnsigned(64);
        hassecondary = true;
      }
    }

    if (hassecondary) {
      if (dataType == DT.ASCII) {
        Uint8List temp = AsciiEncoder().convert(intBitmap.toRadixString(16).toString());
        temp.forEach((element) {
          this._isoMsg[index++] = element;
        });
      } else if ((dataType == DT.BIN) || (dataType == DT.BCD)) {
        Uint8List temp = int2Bcd(intBitmap);

        temp.forEach((element) {
          this._isoMsg[index++] = element;
        });
      }
    }

    memDump("iso msg:", _isoMsg.sublist(0, index));

    return index;
  }

  int buildField(int field, int index) {
    DT dataType = _isoSpec.dataType(field);
    LT lenType = _isoSpec.lengthType(field);
    String contentType = _isoSpec.contentType(field);
    int maxLength = _isoSpec.maxLength(field);
    int len;
    DT lenDataType = _isoSpec.lengthDataType(field);
    String data = this._data.firstWhere((element) => element['field'] == field, orElse: () => null)['data'];

    if (field == 59) {
      field += 0;
    }

    if (lenType == LT.FIXED) {
      len = maxLength;

      if (contentType == 'n') {
      } else if ((contentType.contains('a')) || (contentType.contains('s'))) {
        //   _isoMsg += AsciiEncoder().convert(len.toString());
      } else {
        //  _isoMsg += int2Bcd(len ~/ 2);
      }
    } else {
      String lenString;

      len = data.length;

      if (dataType == DT.BIN) len = len ~/ 2;

      if (len > maxLength) throw 'Cannot Build F{$field}: Field Length larger than specification';

      if (lenType == LT.LVAR) {
        lenString = len.toString().padLeft(1, '0');
        len = 1;
      } else if (lenType == LT.LLVAR) {
        lenString = len.toString().padLeft(2, '0');
        len = 2;
      } else if (lenType == LT.LLLVAR) {
        lenString = len.toString().padLeft(3, '0');
        len = 3;
      }

      if (lenDataType == DT.ASCII)
        _isoMsg += AsciiEncoder().convert(lenString);
      else if (lenDataType == DT.BCD) {
        Uint8List temp = strToBcd(lenString.padLeft(len, '0'));

        temp.forEach((element) {
          this._isoMsg[index++] = element;
        });
      } else if (lenDataType == DT.BIN) {
        _isoMsg.add(len);
      } //TODO fix this length
    }

    if (contentType == 'z') {
      data = data.replaceAll('=', 'D');
      if ((data.length % 2) == 1) data += 'F';
    }

    if (dataType == DT.ASCII) {
      Uint8List temp = AsciiEncoder().convert(data);
      temp.forEach((element) {
        this._isoMsg[index++] = element;
      });
    } else if ((dataType == DT.BIN) || (dataType == DT.BCD)) {
      Uint8List temp = strToBcd(data.padLeft(len, '0'));

      temp.forEach((element) {
        this._isoMsg[index++] = element;
      });
    }
    return index;
  }

  Uint8List buildIso() {
    int index = 0;

    index = buildMID(index);
    memDump("iso msg MID:", _isoMsg.sublist(0, index));

    index = buildBitmap(index);
    memDump("iso msg:", _isoMsg.sublist(0, index));

    for (var i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) {
        index = buildField(i, index);
        memDump("iso msg:", _isoMsg.sublist(0, index));
      }
    }

    return _isoMsg.sublist(0, index);
  }

  int bit(String field, [int value]) {
    if (value == null) {
      return _Bitmap[int.parse(field)];
    } else {
      if ((value == 1) || (value == 0)) {
        _Bitmap[int.parse(field)] = value;
        return _Bitmap[int.parse(field)];
      }
    }
  }

  String fieldData(int field, [String value]) {
    Map<String, dynamic> currentField = this._data.firstWhere((e) => e['field'] == field, orElse: () => null);
    int index = this._data.indexOf(currentField);

    if (value == null) {
      if (currentField != null) {
        this._data[index]['data'] = value;
        return this._data[index]['data'].toString();
      } else
        return null;
    } else {
      this._Bitmap[field] = 1;
      if (currentField == null) {
        Map<String, dynamic> temp = {'field': field, 'data': value};
        this._data.add(temp);
        return temp['data'].toString();
      } else
        this._data[field]['data'] = value;

      return this._data[field]['data'].toString();
    }
  }

  List<int> bitmap() {
    return _Bitmap;
  }

  int setMID([int value]) {
    if (value == null) {
      return _MID;
    } else {
      // TODO: validate these cases
//      if (value.toString().padLeft(0)[1] == '0') throw 'Invalid Message Type';
//      if (int.parse(value.toString().padLeft(0)[3]) > 5) throw 'Invalid Message Origin';

      _MID = value;
      return _MID;
    }
  }

  String description(String field, [String value]) {
    return _isoSpec.description(field, value);
  }

  DT dataType(String field, [DT value]) {
    return _isoSpec.dataType(field, value);
  }

  String contentType(String field, [String value]) {
    return _isoSpec.contectType(field, value);
  }

  void printMessage() {
    String temp = '';
    int i = 0;
    print('MID: [' + _MID.toString() + ']');

    for (var i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) temp += i.toString() + ' ';
    }
    print('Bits: [' + temp + ']');

    for (i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) {
        int len = 0;
        String data = this._data.firstWhere((element) => element['field'] == i, orElse: () => null)['data'];

        temp = i.toString() + ' - ' + _isoSpec.description(i) + ' : (';
        if (_isoSpec.lengthType(i) == LT.FIXED) {
          len = _isoSpec.maxLength(i);
          temp += len.toString();
        } else if ((_isoSpec.lengthType(i) == LT.LVAR) || (_isoSpec.lengthType(i) == LT.LLVAR)) {
          temp += data.length.toString().padLeft(2, '0');
        } else if (_isoSpec.lengthType(i) == LT.LLLVAR) {
          temp += data.length.toString().padLeft(4, '0');
        }
        temp += ') [';

        if (_isoSpec.lengthType(i) == LT.FIXED) {
          temp += data.padLeft(len, '0') + ']';
        } else {
          if (_isoSpec.contentType(i) == 'z') {
            data = data.substring(0, 4) + '********' + data.substring(12);
            temp += data + ']';
          } else {
            if (data.length % 2 == 0)
              temp += data + ']';
            else
              temp += data.padLeft(data.length + 1, '0') + ']';
          }
        }
        print(temp);
      }
    }
  }
}
