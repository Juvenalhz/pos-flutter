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
    if ((i == 0) || (i % 32) != 0) {
      temp += hex.encode(data.sublist(i, i + 1)).toString() + ' ';
    } else if (temp.length > 0) {
      print(temp);
      temp = '';
    }
  }
  if (i == data.length) print(temp);
}

String bcdToStr(Uint8List data) {
  return hex.encode(data);
}

Uint8List strToBcd(String data) {
  return hex.decode(data);
}

int bcd2Int(Uint8List bcd, int len) {
  if ((len > 0) && (len < 5))
    return int.parse(bcdToStr(bcd.sublist(0, len)), radix: 16);
  else
    throw 'Invalid length';
}

Uint8List int2Bcd(int i) {
  String temp = i.toString();
  if (temp.length % 2 == 1) {
    print(temp.padLeft(temp.length + 1, '0'));
  }
  return strToBcd(temp);
}

class Iso8583 {
  List<String> validContentTypes = new List.unmodifiable(['a', 'n', 's', 'an', 'as', 'ns', 'ans', 'b', 'z']);
  bool _strict;
  int _index;
  Uint8List _isoMsg;
  var _isoSpec;
  List<int> _Bitmap = new List(128);
  Map<String, dynamic> _fieldData;
  Map<String, int> _fieldLen;
  String _MTI;

  Iso8583([Uint8List isoMsg, ISOSPEC isoSpec]) {
    if (isoMsg == null) {
      this._isoMsg = new Uint8List(2000);
    } else {
      this._isoMsg = isoMsg;
      parseIso();
    }

    if (isoSpec == null) {
      this._isoSpec = new IsoSpecASCII();
    } else {
      if (isoSpec == ISOSPEC.ISO_1987)
        this._isoSpec = new Iso8583Specs();
      else if (isoSpec == ISOSPEC.ISO_ASCII)
        this._isoSpec = new IsoSpecASCII();
      else if (isoSpec == ISOSPEC.ISO_BCD)
        this._isoSpec = new IsoSpecBCD();
      else
        throw 'Wrong ISO type';
    }
    this._strict = false;
    this._index = 0;
  }

  void setStrict(bool value) {
    this._strict = value;
  }

  void setIsoContect(Uint8List isoMsg) {
    this._isoMsg = isoMsg;
    parseIso();
  }

  int parseMTI(Uint8List p) {
    DT dataType = this._isoSpec.dataType('MTI');

    if (dataType == DT.BCD) {
      this._MTI = bcdToStr(this._isoMsg.sublist(_index, _index + 2));
      _index += 2;
    } else if (dataType == DT.ASCII) {
      this._MTI = this._isoMsg.sublist(_index, _index + 4).toString();
      _index += 4;
    }

    try {
      int test = int.parse(this._MTI);
    } catch (e) {
      throw "Invalid MTI";
    }

    if (_strict == true) {
      if (_MTI[1] == '0') throw 'Invalid MTI: Invalid Message type';
      if (int.parse(this._MTI[3]) > 5) throw 'Invalid MTI: Invalid Message origin ';
    }

    return _index;
  }

  int parseBitmap(int index) {
    DT dataType = _isoSpec.dataType('1');
    Uint8List bitmapBuffer;
    int intBitmap;

    if (dataType == DT.BIN) {
      bitmapBuffer = _isoMsg.sublist(index, index + 8);
      index += 8;
    } else if (dataType == DT.ASCII) {
      bitmapBuffer = strToBcd(_isoMsg.sublist(index, index + 16).toString());
      index += 16;
    }

    intBitmap = int.parse(bitmapBuffer.toString());
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
      intBitmap = int.parse(bitmapBuffer.toString());
      for (var i = 0; i < 65; i++) {
        _Bitmap[i + 64] = intBitmap >> (64 - i) & 1;
      }
    }
    return index;
  }

  int parseField(String field, int index) {
    var dataType;
    var contentType;
    var maxLength;
    int len;
    DT lenDataType;
    LT lenType;

    print('ParseFiedl' + field);

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
        len = bcd2Int(_isoMsg, 2);
        index += 2;
      } else if (lenDataType == DT.BCD) {
        len = bcd2Int(_isoMsg, 1);
        index += 1;
      } else if (lenDataType == DT.BIN) {
        len = _isoMsg[index];
        index += 1;
      }
    } else if (lenType == LT.LLLVAR) {
      lenDataType = _isoSpec.lengthDataType(field);
      if (lenDataType == DT.ASCII) {
        len = bcd2Int(_isoMsg, 3);
        index += 3;
      } else if (lenDataType == DT.BCD) {
        len = bcd2Int(_isoMsg, 2);
        index += 2;
      } else if (lenDataType == DT.BIN) {
        len = _isoMsg[index]; //TODO fix this legnth as it needs 2 bytes
        index += 2;
      }
    }
    if (len > maxLength) throw "Flield $field is larger than maximum length $len > $maxLength";

    _fieldLen[field] = len;

    if (len == 0) return index; // In case of zero length, don't try to parse the field itself, just continue

    if (dataType == DT.ASCII) {
      if (contentType == 'n') {
        _fieldData[field] = _isoMsg.sublist(index, index + len);
      } else {
        _fieldData[field] = AsciiDecoder().convert(_isoMsg.sublist(index, index + len));
      }
      index += len;
    } else if (dataType == DT.BCD) {
      if (len % 2 == 1) len += 1;
      if (contentType == 'n') {
        _fieldData[field] = bcdToStr(_isoMsg.sublist(index, index + (len ~/ 2)));
        index += len ~/ 2;
      } else if (contentType == 'z') {
        _fieldData[field] = AsciiDecoder().convert(_isoMsg.sublist(index, index + (len ~/ 2))).toUpperCase();
        index += len ~/ 2;
      }
      index += len ~/ 2;
    } else if (dataType == DT.BIN) {
      _fieldData[field] = AsciiDecoder().convert(_isoMsg.sublist(index, index + (len))).toUpperCase();
      index += len;
    }

    if (contentType == 'z') {
      _fieldData[field] = _fieldData[field].toString().replaceAll('D', '=');
      _fieldData[field] = _fieldData[field].toString().replaceAll('F', '');
    }

    print('Field[$field]: $_fieldData[field]');
    return index;
  }

  void parseIso() {
    int index = 0;

    index = parseMTI(_isoMsg);
    index = parseBitmap(index);

    for (var b in _Bitmap) {
      if (b == 1) {
        index = parseField(b.toString(), index);
      }
    }
  }

  void buildMTI() {
    if (_isoSpec.dataType("MTI") == DT.BCD)
      _isoMsg += strToBcd(_MTI);
    else if (_isoSpec.dataType("MTI") == DT.ASCII) _isoMsg += AsciiEncoder().convert(_MTI);
  }

  void buildBitmap() {
    int intBitmap;
    bool hassecondary = false;

    DT dataType = _isoSpec.dataType('1');

    //primary bitmap
    for (var i = 0; i < 65; i++) {
      if (_Bitmap[i] == 1) intBitmap |= (1 << 64 - i);
    }
    if (dataType == DT.BIN)
      _isoMsg.add(intBitmap);
    else if (dataType == DT.ASCII) _isoMsg += AsciiEncoder().convert(intBitmap.toString());

    //secondary bitmap
    for (var i = 65; i < 129; i++) {
      if (_Bitmap[i] == 1) {
        intBitmap |= (1 << 64 - i);
        hassecondary = true;
      }
    }
    if (hassecondary) {
      if (dataType == DT.BIN)
        _isoMsg.add(intBitmap);
      else if (dataType == DT.ASCII) _isoMsg += AsciiEncoder().convert(intBitmap.toString());
    }
  }

  void buildField(String field) {
    DT dataType = _isoSpec.dataType(field);
    LT lenType = _isoSpec.lengthType(field);
    String contentType = _isoSpec.contentType(field);
    int maxLength = _isoSpec.maxLength(field);
    int len;
    int lenDataType = _isoSpec.lengthDataType(field);
    String data = _fieldData[field];

    if (lenType == LT.FIXED) {
      len = maxLength;

      if (contentType == 'n') {
        _isoMsg += int2Bcd(len);
      } else if ((contentType.contains('a')) || (contentType.contains('s'))) {
        _isoMsg += AsciiEncoder().convert(len.toString());
      } else {
        _isoMsg += int2Bcd(len ~/ 2);
      }
    } else {
      String lenString;

      len = _fieldData[field].length();

      if (dataType == DT.BIN) len = len ~/ 2;

      if (len > maxLength) throw 'Cannot Build F{$field}: Field Length larger than specification';

      if (lenType == LT.LVAR)
        lenString = len.toString().padLeft(1, '0');
      else if (lenType == LT.LLVAR)
        lenString = len.toString().padLeft(2, '0');
      else if (lenType == LT.LLLVAR) lenString = len.toString().padLeft(3, '0');

      if (lenDataType == DT.ASCII)
        _isoMsg += AsciiEncoder().convert(lenString);
      else if (lenDataType == DT.BCD)
        _isoMsg += strToBcd(lenString);
      else if (lenDataType == DT.BIN) _isoMsg.add(len); //TODO fix this length
    }

    if (contentType == 'z') {
      data = data.replaceAll('=', 'D');
      if ((data.length % 2) == 1) data += 'F';
    }

    if (dataType == DT.ASCII)
      _isoMsg += AsciiEncoder().convert(data);
    else if (dataType == DT.BCD)
      _isoMsg += strToBcd(data);
    else if (dataType == DT.BIN) _isoMsg += hex.decode(data);
  }

  Uint8List buildIso() {
    buildMTI();
    buildBitmap();

    for (var i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) buildField(i.toString());
    }

    return _isoMsg;
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

  String fieldData(String field, [String value]) {
    if (value == null) {
      return _fieldData[field];
    } else {
      if (value.length > _isoSpec.maxLength(field)) throw 'Value length larger than field maximum';

      _fieldData[field] = value;
      _Bitmap[int.parse(field)] = 1;
    }
  }

  List<int> bitmap() {
    return _Bitmap;
  }

  String MTI([String value]) {
    if (value == null) {
      return _MTI;
    } else {
      try {
        int.parse(value);
      } catch (e) {
        throw 'Invalid MTI it must contain only numbers';
      }

      if (value[1] == '0') throw 'Invalid Message Type';
      if (int.parse(value[3]) > 5) throw 'Invalid Message Origin';

      _MTI = value;
      return _MTI;
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
    String temp;

    print('MTI: [' + _MTI + ']');

    for (var i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) temp += i.toString() + ' ';
    }
    print('Flieds: [' + temp + ']');

    for (var i = 0; i < _Bitmap.length; i++) {
      if (_Bitmap[i] == 1) {
        if ((this.contentType(i.toString()) == 'n') && (_isoSpec[i.toString()].lenthType == LT.FIXED)) {
          print('$i - ' +
              _isoSpec.descrption(i.toString()) +
              ' : (' +
              _fieldLen[i].toString() +
              ') [' +
              _fieldData[i.toString()] +
              ']');
        } else {
          print('$i - ' +
              _isoSpec.descrption(i.toString()) +
              ' : (' +
              _fieldLen[i].toString() +
              ') [' +
              _fieldData[i.toString()] +
              ']');
        }
      }
    }
  }
}

/*


def DictMessage(self):
dict_msg = {}

dict_msg['mti'] = "{0}".format(self.__MTI)
dict_msg['bitmap'] = []

for i in sorted(self.__Bitmap.keys()):
if (i == 1):
continue
if (self.__Bitmap[i] == 1):
dict_msg['bitmap'].append(i)

for i in sorted(self.__Bitmap.keys()):
if (i == 1):
continue
if (self.__Bitmap[i] == 1):

try:
FieldData = self.__FieldData[i]
except KeyError:
FieldData = ''

if (self.ContentType(i) == 'n' and self.__IsoSpec.LengthType(i) == LT.FIXED):
FieldData = str(FieldData).zfill(self.__IsoSpec.MaxLength(i))

#Len = self.__FieldLen[i]
Len = len(FieldData)

dict_msg["F{0:>03d}".format(i)] = {'data': FieldData, 'length': Len}

return dict_msg
*/
