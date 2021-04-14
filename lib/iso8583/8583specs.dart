import 'dart:core';
import '8583.dart';

const List<String> validContentTypes = ['a', 'n', 's', 'an', 'as', 'ns', 'ans', 'b', 'z'];
const int MID = 9999;

class IsoField {
  int field;
  String description;
  String contentType;
  LT lengthType;
  DT lengthDataType;
  DT dataType;
  int maxLength;

  IsoField(this.field, {this.description, this.contentType, this.lengthDataType, this.dataType, this.maxLength, this.lengthType});
}

class Iso8583Specs {
//  var descriptionValue = new Map();
//  var contentTypesValue = new Map();
//  var dataTypeValue = new Map();
  List<IsoField> fields = new List<IsoField>();

//  Map get description_Value {
//    return descriptionValue;
//  }
//
//  Map get content_Types_Value {
//    return contentTypesValue;
//  }
//
//  Map get data_Type_Value {
//    return dataTypeValue;
//  }

  String description(int field, [String description]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (description == null) {
      if (currentField != null) {
        return this.fields[index].description;
      } else
        return null;
    } else {
      if (currentField == null) {
        IsoField temp = new IsoField(field, description: description);
        this.fields.add(temp);
        return temp.description;
      } else
        return this.fields[index].description;
    }
  }

  DT dataType(int field, [DT datatype]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (datatype == null) {
      if (currentField != null) {
        return this.fields[index].dataType;
      } else
        return null;
    } else {
      switch (datatype) {
        case DT.BCD:
        case DT.ASCII:
        case DT.BIN:
          {
            if (currentField == null) {
              IsoField temp = new IsoField(field, dataType: datatype);
              this.fields.add(temp);
              return temp.dataType;
            } else {
              this.fields[index].dataType = datatype;
              return this.fields[index].dataType;
            }
          }
          break;
        default:
          {
            throw ("Cannot set data type $datatype for Field $field: Invalid data type");
          }
          break;
      }
    }
  }

  String contentType(int field, [String contentType]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (contentType == null) {
      if (currentField != null) {
        return this.fields[index].contentType;
      } else
        return null;
    } else {
      if (validContentTypes.contains(contentType)) {
        if (currentField == null) {
          IsoField temp = new IsoField(field, contentType: contentType);
          this.fields.add(temp);
          return temp.contentType;
        } else {
          this.fields[field].contentType = contentType;
          return this.fields[field].contentType;
        }
      } else
        throw ("Cannot set Content type $contentType for Field $field: Invalid content type");
    }
  }

  int maxLength(int field, [int maxLength]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (maxLength == null) {
      if (currentField != null) {
        return this.fields[index].maxLength;
      } else
        return null;
    } else {
      if (currentField == null) {
        IsoField temp = new IsoField(field, maxLength: maxLength);
        this.fields.add(temp);
        return temp.maxLength;
      } else {
        this.fields[index].maxLength = maxLength;
        return this.fields[index].maxLength;
      }
    }
  }

  LT lengthType(int field, [LT lengthType]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (lengthType == null) {
      if (currentField != null) {
        return this.fields[index].lengthType;
      } else
        return null;
    } else {
      switch (lengthType) {
        case LT.FIXED:
        case LT.LVAR:
        case LT.LLVAR:
        case LT.LLLVAR:
          {
            if (currentField == null) {
              IsoField temp = new IsoField(field, lengthType: lengthType);
              this.fields.add(temp);
              return temp.lengthType;
            } else {
              this.fields[index].lengthType = lengthType;
              return this.fields[index].lengthType;
            }
          }
          break;
        default:
          {
            throw ("Cannot set Length type $lengthType for Field $field: Invalid length type");
          }
          break;
      }
    }
  }

  DT lengthDataType(int field, [DT lengthDataType]) {
    IsoField currentField = this.fields.firstWhere((e) => e.field == field, orElse: () => null);
    int index = this.fields.indexOf(currentField);

    if (lengthDataType == null) {
      if (currentField != null) {
        return this.fields[index].lengthDataType;
      } else
        return null;
    } else {
      switch (lengthDataType) {
        case DT.BCD:
        case DT.ASCII:
        case DT.BIN:
          {
            if (currentField == null) {
              IsoField temp = new IsoField(field, lengthDataType: lengthDataType);
              this.fields.add(temp);
              return temp.lengthDataType;
            } else {
              this.fields[index].lengthDataType = lengthDataType;
              return this.fields[index].lengthDataType;
            }
          }
          break;
        default:
          {
            throw ("Cannot set data type $lengthDataType for Field $field: Invalid data type");
          }
          break;
      }
    }
  }

  void _addField(IsoField field) {
    fields.add(field);
  }
}

class IsoSpec1987 extends Iso8583Specs {
  IsoSpec1987() {
    dataType(MID, DT.BCD);
    dataType(1, DT.BCD);

    contentTypes1987.asMap().forEach((key, value) {
      IsoField temp = new IsoField(value['field'], contentType: value['ContentType'], maxLength: value['MaxLen'], lengthType: value['LenType']);
      _addField(temp);
    });
  }
}

class IsoSpecASCII extends Iso8583Specs {
  IsoSpecASCII() {
    dataType(MID, DT.ASCII);
    dataType(1, DT.ASCII);

    contentTypes1987.asMap().forEach((key, value) {
      IsoField temp = new IsoField(value['field'],
          contentType: value['ContentType'], maxLength: value['MaxLen'], lengthType: value['LenType'], description: value['description']);

      temp.dataType = DT.ASCII;

      if (temp.lengthType != LT.FIXED) temp.lengthDataType = DT.ASCII;

      _addField(temp);
    });
  }
}

class IsoSpecBCD extends Iso8583Specs {
  IsoSpecBCD() {
    dataType(MID, DT.BCD);
    dataType(1, DT.BCD);

    contentTypes1987.asMap().forEach((key, value) {
      IsoField temp = new IsoField(value['field'],
          contentType: value['ContentType'], maxLength: value['MaxLen'], lengthType: value['LenType'], description: value['description']);

      if (temp.contentType.contains('a') || temp.contentType.contains('s'))
        temp.dataType = DT.ASCII;
      else if (temp.contentType.contains('b'))
        temp.dataType = DT.BIN;
      else if ((temp.contentType == 'an') || (temp.contentType == 'as') || (temp.contentType == 'ns') || (temp.contentType == 'ans'))
        temp.dataType = DT.ASCII;
      else
        temp.dataType = DT.BCD;

      if (temp.lengthType != LT.FIXED) temp.lengthDataType = DT.BIN;

      _addField(temp);
    });

    lengthDataType(2, DT.BCD);
    lengthType(2, LT.LLVAR);
  }
}

var contentTypes1987 = new List<Map<String, dynamic>>.unmodifiable({
  {'field': 1, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Bitmap'},
  {'field': 2, 'ContentType': 'n', 'MaxLen': 19, 'LenType': LT.LLVAR, 'description': 'Primary account number (PAN)'},
  {'field': 3, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED, 'description': 'Processing code'},
  {'field': 4, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Amount, transaction'},
  {'field': 5, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Amount, settlement'},
  {'field': 6, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Amount, cardholder billing'},
  {'field': 7, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Transmission date & time'},
  {'field': 8, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Amount, cardholder billing fee'},
  {'field': 9, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Conversion rate, settlement'},
  {'field': 10, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Conversion rate, cardholder billing'},
  {'field': 11, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED, 'description': 'System trace audit number'},
  {'field': 12, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED, 'description': 'Time, local transaction (hhmmss)'},
  {'field': 13, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Date, local transaction (MMDD)'},
  {'field': 14, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Date, expiration'},
  {'field': 15, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Date, settlement'},
  {'field': 16, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Date, conversion'},
  {'field': 17, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Date, capture'},
  {'field': 18, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Merchant type'},
  {'field': 19, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Acquiring institution country code'},
  {'field': 20, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'PAN extended, country code'},
  {'field': 21, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Forwarding institution. country code'},
  {'field': 22, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Point of service entry mode'},
  {'field': 23, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Application PAN sequence number'},
  {'field': 24, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Network International identifier (NII)'},
  {'field': 25, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED, 'description': 'Point of service condition code'},
  {'field': 26, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED, 'description': 'Point of service capture code'},
  {'field': 27, 'ContentType': 'n', 'MaxLen': 1, 'LenType': LT.FIXED, 'description': 'Authorizing identification response length'},
  {'field': 28, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED, 'description': 'Amount, transaction fee'},
  {'field': 29, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED, 'description': 'Amount, settlement fee'},
  {'field': 30, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED, 'description': 'Amount, transaction processing fee'},
  {'field': 31, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED, 'description': 'Amount, settlement processing fee'},
  {'field': 32, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR, 'description': 'Acquiring institution identification code'},
  {'field': 33, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR, 'description': 'Forwarding institution identification code'},
  {'field': 34, 'ContentType': 'ns', 'MaxLen': 28, 'LenType': LT.LLVAR, 'description': 'Primary account number, extended'},
  {'field': 35, 'ContentType': 'z', 'MaxLen': 40, 'LenType': LT.LLVAR, 'description': 'Track 2 data'},
  {'field': 36, 'ContentType': 'n', 'MaxLen': 104, 'LenType': LT.LLLVAR, 'description': 'Track 3 data'},
  {'field': 37, 'ContentType': 'an', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Retrieval reference number'},
  {'field': 38, 'ContentType': 'an', 'MaxLen': 6, 'LenType': LT.FIXED, 'description': 'Authorization identification response'},
  {'field': 39, 'ContentType': 'an', 'MaxLen': 2, 'LenType': LT.FIXED, 'description': 'Response code'},
  {'field': 40, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Service restriction code'},
  {'field': 41, 'ContentType': 'ans', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Card acceptor terminal identification'},
  {'field': 42, 'ContentType': 'ans', 'MaxLen': 15, 'LenType': LT.FIXED, 'description': 'Card acceptor identification code'},
  {'field': 43, 'ContentType': 'ans', 'MaxLen': 73, 'LenType': LT.FIXED, 'description': 'Card acceptor name/location'},
  {'field': 44, 'ContentType': 'an', 'MaxLen': 25, 'LenType': LT.LLVAR, 'description': 'Additional response data'},
  {'field': 45, 'ContentType': 'an', 'MaxLen': 76, 'LenType': LT.LLVAR, 'description': 'Track 1 data'},
  {'field': 46, 'ContentType': 'an', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Additional data - ISO'},
  {'field': 47, 'ContentType': 'an', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Additional data - national'},
  {'field': 48, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Additional data - private'},
  {'field': 49, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Currency code, transaction'},
  {'field': 50, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Currency code, settlement'},
  {'field': 51, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Currency code, cardholder billing'},
  {'field': 52, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Personal identification number data'},
  {'field': 53, 'ContentType': 'ans', 'MaxLen': 20, 'LenType': LT.FIXED, 'description': 'Security related control information'},
  {'field': 54, 'ContentType': 'an', 'MaxLen': 120, 'LenType': LT.LLLVAR, 'description': 'Additional amounts'},
  {'field': 55, 'ContentType': 'b', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved ISO'},
  {'field': 56, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved ISO'},
  {'field': 57, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved national'},
  {'field': 58, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved national'},
  {'field': 59, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved national'},
  {'field': 60, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved national'},
  {'field': 61, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved private'},
  {'field': 62, 'ContentType': 'b', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved private'},
  {'field': 63, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved private'},
  {'field': 64, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Message authentication code (MAC)'},
  {'field': 65, 'ContentType': 'b', 'MaxLen': 1, 'LenType': LT.FIXED, 'description': 'Bitmap, extended'},
  {'field': 66, 'ContentType': 'n', 'MaxLen': 1, 'LenType': LT.FIXED, 'description': 'Settlement code'},
  {'field': 67, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED, 'description': 'Extended payment code'},
  {'field': 68, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Receiving institution country code'},
  {'field': 69, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Settlement institution country code'},
  {'field': 70, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED, 'description': 'Network management information code'},
  {'field': 71, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Message number'},
  {'field': 72, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED, 'description': 'Message number, last'},
  {'field': 73, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED, 'description': 'Date, action (YYMMDD)'},
  {'field': 74, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Credits, number'},
  {'field': 75, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Credits, reversal number'},
  {'field': 76, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Debits, number'},
  {'field': 77, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Debits, reversal number'},
  {'field': 78, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Transfer number'},
  {'field': 79, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Transfer, reversal number'},
  {'field': 80, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Inquiries number'},
  {'field': 81, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED, 'description': 'Authorizations, number'},
  {'field': 82, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Credits, processing fee amount'},
  {'field': 83, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Credits, transaction fee amount'},
  {'field': 84, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Debits, processing fee amount'},
  {'field': 85, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED, 'description': 'Debits, transaction fee amount'},
  {'field': 86, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED, 'description': 'Credits, amount'},
  {'field': 87, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED, 'description': 'Credits, reversal amount'},
  {'field': 88, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED, 'description': 'Debits, amount'},
  {'field': 89, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED, 'description': 'Debits, reversal amount'},
  {'field': 90, 'ContentType': 'n', 'MaxLen': 42, 'LenType': LT.FIXED, 'description': 'Original data elements'},
  {'field': 91, 'ContentType': 'an', 'MaxLen': 1, 'LenType': LT.FIXED, 'description': 'File update code'},
  {'field': 92, 'ContentType': 'an', 'MaxLen': 2, 'LenType': LT.FIXED, 'description': 'File security code'},
  {'field': 93, 'ContentType': 'an', 'MaxLen': 5, 'LenType': LT.FIXED, 'description': 'Response indicator'},
  {'field': 94, 'ContentType': 'an', 'MaxLen': 7, 'LenType': LT.FIXED, 'description': 'Service indicator'},
  {'field': 95, 'ContentType': 'an', 'MaxLen': 42, 'LenType': LT.FIXED, 'description': 'Replacement amounts'},
  {'field': 96, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Message security code'},
  {'field': 97, 'ContentType': 'an', 'MaxLen': 17, 'LenType': LT.FIXED, 'description': 'Amount, net settlement'},
  {'field': 98, 'ContentType': 'ans', 'MaxLen': 25, 'LenType': LT.FIXED, 'description': 'Payee'},
  {'field': 99, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR, 'description': 'Settlement institution identification code'},
  {'field': 100, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR, 'description': 'Receiving institution identification code'},
  {'field': 101, 'ContentType': 'ans', 'MaxLen': 17, 'LenType': LT.LLVAR, 'description': 'File name'},
  {'field': 102, 'ContentType': 'ans', 'MaxLen': 28, 'LenType': LT.LLVAR, 'description': 'Account identification 1'},
  {'field': 103, 'ContentType': 'ans', 'MaxLen': 28, 'LenType': LT.LLVAR, 'description': 'Account identification 2'},
  {'field': 104, 'ContentType': 'ans', 'MaxLen': 100, 'LenType': LT.LLLVAR, 'description': 'Transaction description'},
  {'field': 105, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 106, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 107, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 108, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 109, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 110, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 111, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for ISO use'},
  {'field': 112, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 113, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 114, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 115, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 116, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 117, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 118, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 119, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for national use'},
  {'field': 120, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 121, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 122, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 123, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 124, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 125, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 126, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 127, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR, 'description': 'Reserved for private use'},
  {'field': 128, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED, 'description': 'Message authentication code'}
});
