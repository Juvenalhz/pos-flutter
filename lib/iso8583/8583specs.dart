import 'dart:core';
import 'package:intl/intl.dart';
import '8583.dart';

var validContentTypes = {'a', 'n', 's', 'an', 'as', 'ns', 'ans', 'b', 'z'} as List<String>;

class Iso8583Specs {
  var descriptionValue = new Map();
  var contentTypesValue = new Map();
  var dataTypeValue = new Map();

  Map get description_Value {
    return descriptionValue;
  }

  Map get content_Types_Value {
    return contentTypesValue;
  }

  Map get data_Type_Value {
    return dataTypeValue;
  }

  String description(String field, [String description]) {
    if (description != null) {
      this.descriptionValue[field] = description;
    }
    return this.descriptionValue[field];
  }

  DT dataType(String field, [DT datatype]) {
    if (datatype == null) {
      return this.dataTypeValue[field]['Data'];
    } else {
      switch (datatype) {
        case DT.BCD:
        case DT.ASCII:
        case DT.BIN:
          {
            this.dataTypeValue[field]['Data'] = datatype;
          }
          break;
        default:
          {
            throw ("Cannot set data type $datatype for Field $field: Invalid data type");
          }
          break;
      }
    }
    return this.dataTypeValue[field]['Data'];
  }

  String contentType(String field, [String contentType]) {
    if (contentType == null)
      return this.contentTypesValue[field]['ContentType'];
    else {
      if (validContentTypes.contains(contentType))
        this.contentTypesValue[field]['ContentType'] = contentType;
      else
        throw ("Cannot set Content type $contentType for Field $field: Invalid content type");
    }
    return this.contentTypesValue[field]['ContentType'];
  }

  int maxLength(String field, [int max_Length]) {
    if (max_Length == null)
      return this.contentTypesValue[field]['MaxLen'];
    else
      this.contentTypesValue[field]['MaxLen'] = max_Length;

    return this.contentTypesValue[field]['MaxLen'];
  }

  LT lengthType(String field, [LT length_Type]) {
    if (length_Type == null)
      return this.contentTypesValue[field]['LenType'];
    else {
      switch (length_Type) {
        case LT.FIXED:
        case LT.LVAR:
        case LT.LLVAR:
        case LT.LLLVAR:
          {
            this.dataTypeValue[field]['LenType'] = length_Type;
          }
          break;
        default:
          {
            throw ("Cannot set Length type $length_Type for Field $field: Invalid length type");
          }
          break;
      }
    }
    return this.contentTypesValue[field]['LenType'];
  }

  DT lengthDataType(String field, [DT length_Data_Type]) {
    if (length_Data_Type == null)
      return this.dataTypeValue[field]['Length'];
    else {
      switch (length_Data_Type) {
        case DT.BCD:
        case DT.ASCII:
        case DT.BIN:
          {
            this.dataTypeValue[field]['Length'] = length_Data_Type;
          }
          break;
        default:
          {
            throw ("Cannot set data type $length_Data_Type for Field $field: Invalid data type");
          }
          break;
      }
    }
    return this.dataTypeValue[field]['Length'];
  }
}

class IsoSpec1987 extends Iso8583Specs {
  var descriptions = List.from(Descriptions1987);
  var contentTypeValues = List.from(ContentTypes1987);

  IsoSpec1987() {
    dataType('MTI', DT.BCD);
    dataType('1', DT.BCD);
  }
}

class IsoSpecASCII extends Iso8583Specs {
  var descriptions = List.from(Descriptions1987);
  var contentTypeValues = List.from(ContentTypes1987);

  IsoSpecASCII() {
    dataType('MTI', DT.ASCII);
    dataType('1', DT.ASCII);

    for (var i = 0; i < contentTypeValues.length; i++) {
      dataType(contentTypeValues[i]['filed'], DT.ASCII);
      if (contentTypeValues[i]['LenType'] != LT.FIXED) lengthDataType(contentTypeValues[i], DT.ASCII);
    }
  }
}

class IsoSpecBCD extends Iso8583Specs {
  var descriptions = List.from(Descriptions1987);
  var contentTypeValues = List.from(ContentTypes1987);

  IsoSpecBCD() {
    dataType('MTI', DT.BCD);
    dataType('1', DT.BIN);

    for (var i = 0; i < contentTypeValues.length; i++) {
      if ((contentTypeValues[i]['ContentType'].toString().contains('a')) ||
          (contentTypeValues[i]['ContentType'].toString().contains('s'))) {
        dataType(contentTypeValues[i]['field'], DT.ASCII);
      } else if (contentTypeValues[i]['ContentType'].toString().contains('b')) {
        dataType(contentTypeValues[i]['field'], DT.BIN);
      } else if ((contentTypeValues[i]['ContentType'].toString().contains('an')) ||
          (contentTypeValues[i]['ContentType'].toString().contains('as')) ||
          (contentTypeValues[i]['ContentType'].toString().contains('ns')) ||
          (contentTypeValues[i]['ContentType'].toString().contains('ans'))) {
        dataType(contentTypeValues[i]['field'], DT.ASCII);
      } else
        dataType(contentTypeValues[i]['field'], DT.BCD);
    }
  }
}

var Descriptions1987 = new List<Map<String, dynamic>>.unmodifiable({
  {'field': 1, 'desciption': 'Bitmap'},
  {'field': 2, 'desciption': 'Primary account number (PAN)'},
  {'field': 3, 'desciption': 'Processing code'},
  {'field': 4, 'desciption': 'Amount, transaction'},
  {'field': 5, 'desciption': 'Amount, settlement'},
  {'field': 6, 'desciption': 'Amount, cardholder billing'},
  {'field': 7, 'desciption': 'Transmission date & time'},
  {'field': 8, 'desciption': 'Amount, cardholder billing fee'},
  {'field': 9, 'desciption': 'Conversion rate, settlement'},
  {'field': 10, 'desciption': 'Conversion rate, cardholder billing'},
  {'field': 11, 'desciption': 'System trace audit number'},
  {'field': 12, 'desciption': 'Time, local transaction (hhmmss)'},
  {'field': 13, 'desciption': 'Date, local transaction (MMDD)'},
  {'field': 14, 'desciption': 'Date, expiration'},
  {'field': 15, 'desciption': 'Date, settlement'},
  {'field': 16, 'desciption': 'Date, conversion'},
  {'field': 17, 'desciption': 'Date, capture'},
  {'field': 18, 'desciption': 'Merchant type'},
  {'field': 19, 'desciption': 'Acquiring institution country code'},
  {'field': 20, 'desciption': 'PAN extended, country code'},
  {'field': 21, 'desciption': 'Forwarding institution. country code'},
  {'field': 22, 'desciption': 'Point of service entry mode'},
  {'field': 23, 'desciption': 'Application PAN sequence number'},
  {'field': 24, 'desciption': 'Network International identifier (NII)'},
  {'field': 25, 'desciption': 'Point of service condition code'},
  {'field': 26, 'desciption': 'Point of service capture code'},
  {'field': 27, 'desciption': 'Authorizing identification response length'},
  {'field': 28, 'desciption': 'Amount, transaction fee'},
  {'field': 29, 'desciption': 'Amount, settlement fee'},
  {'field': 30, 'desciption': 'Amount, transaction processing fee'},
  {'field': 31, 'desciption': 'Amount, settlement processing fee'},
  {'field': 32, 'desciption': 'Acquiring institution identification code'},
  {'field': 33, 'desciption': 'Forwarding institution identification code'},
  {'field': 34, 'desciption': 'Primary account number, extended'},
  {'field': 35, 'desciption': 'Track 2 data'},
  {'field': 36, 'desciption': 'Track 3 data'},
  {'field': 37, 'desciption': 'Retrieval reference number'},
  {'field': 38, 'desciption': 'Authorization identification response'},
  {'field': 39, 'desciption': 'Response code'},
  {'field': 40, 'desciption': 'Service restriction code'},
  {'field': 41, 'desciption': 'Card acceptor terminal identification'},
  {'field': 42, 'desciption': 'Card acceptor identification code'},
  {'field': 43, 'desciption': 'Card acceptor name/location'},
  {'field': 44, 'desciption': 'Additional response data'},
  {'field': 45, 'desciption': 'Track 1 data'},
  {'field': 46, 'desciption': 'Additional data - ISO'},
  {'field': 47, 'desciption': 'Additional data - national'},
  {'field': 48, 'desciption': 'Additional data - private'},
  {'field': 49, 'desciption': 'Currency code, transaction'},
  {'field': 50, 'desciption': 'Currency code, settlement'},
  {'field': 51, 'desciption': 'Currency code, cardholder billing'},
  {'field': 52, 'desciption': 'Personal identification number data'},
  {'field': 53, 'desciption': 'Security related control information'},
  {'field': 54, 'desciption': 'Additional amounts'},
  {'field': 55, 'desciption': 'Reserved ISO'},
  {'field': 56, 'desciption': 'Reserved ISO'},
  {'field': 57, 'desciption': 'Reserved national'},
  {'field': 58, 'desciption': 'Reserved national'},
  {'field': 59, 'desciption': 'Reserved national'},
  {'field': 60, 'desciption': 'Reserved national'},
  {'field': 61, 'desciption': 'Reserved private'},
  {'field': 62, 'desciption': 'Reserved private'},
  {'field': 63, 'desciption': 'Reserved private'},
  {'field': 64, 'desciption': 'Message authentication code (MAC)'},
  {'field': 65, 'desciption': 'Bitmap, extended'},
  {'field': 66, 'desciption': 'Settlement code'},
  {'field': 67, 'desciption': 'Extended payment code'},
  {'field': 68, 'desciption': 'Receiving institution country code'},
  {'field': 69, 'desciption': 'Settlement institution country code'},
  {'field': 70, 'desciption': 'Network management information code'},
  {'field': 71, 'desciption': 'Message number'},
  {'field': 72, 'desciption': 'Message number, last'},
  {'field': 73, 'desciption': 'Date, action (YYMMDD)'},
  {'field': 74, 'desciption': 'Credits, number'},
  {'field': 75, 'desciption': 'Credits, reversal number'},
  {'field': 76, 'desciption': 'Debits, number'},
  {'field': 77, 'desciption': 'Debits, reversal number'},
  {'field': 78, 'desciption': 'Transfer number'},
  {'field': 79, 'desciption': 'Transfer, reversal number'},
  {'field': 80, 'desciption': 'Inquiries number'},
  {'field': 81, 'desciption': 'Authorizations, number'},
  {'field': 82, 'desciption': 'Credits, processing fee amount'},
  {'field': 83, 'desciption': 'Credits, transaction fee amount'},
  {'field': 84, 'desciption': 'Debits, processing fee amount'},
  {'field': 85, 'desciption': 'Debits, transaction fee amount'},
  {'field': 86, 'desciption': 'Credits, amount'},
  {'field': 87, 'desciption': 'Credits, reversal amount'},
  {'field': 88, 'desciption': 'Debits, amount'},
  {'field': 89, 'desciption': 'Debits, reversal amount'},
  {'field': 90, 'desciption': 'Original data elements'},
  {'field': 91, 'desciption': 'File update code'},
  {'field': 92, 'desciption': 'File security code'},
  {'field': 93, 'desciption': 'Response indicator'},
  {'field': 94, 'desciption': 'Service indicator'},
  {'field': 95, 'desciption': 'Replacement amounts'},
  {'field': 96, 'desciption': 'Message security code'},
  {'field': 97, 'desciption': 'Amount, net settlement'},
  {'field': 98, 'desciption': 'Payee'},
  {'field': 99, 'desciption': 'Settlement institution identification code'},
  {'field': 100, 'desciption': 'Receiving institution identification code'},
  {'field': 101, 'desciption': 'File name'},
  {'field': 102, 'desciption': 'Account identification 1'},
  {'field': 103, 'desciption': 'Account identification 2'},
  {'field': 104, 'desciption': 'Transaction description'},
  {'field': 105, 'desciption': 'Reserved for ISO use'},
  {'field': 106, 'desciption': 'Reserved for ISO use'},
  {'field': 107, 'desciption': 'Reserved for ISO use'},
  {'field': 108, 'desciption': 'Reserved for ISO use'},
  {'field': 109, 'desciption': 'Reserved for ISO use'},
  {'field': 110, 'desciption': 'Reserved for ISO use'},
  {'field': 111, 'desciption': 'Reserved for ISO use'},
  {'field': 112, 'desciption': 'Reserved for national use'},
  {'field': 113, 'desciption': 'Reserved for national use'},
  {'field': 114, 'desciption': 'Reserved for national use'},
  {'field': 115, 'desciption': 'Reserved for national use'},
  {'field': 116, 'desciption': 'Reserved for national use'},
  {'field': 117, 'desciption': 'Reserved for national use'},
  {'field': 118, 'desciption': 'Reserved for national use'},
  {'field': 119, 'desciption': 'Reserved for national use'},
  {'field': 120, 'desciption': 'Reserved for private use'},
  {'field': 121, 'desciption': 'Reserved for private use'},
  {'field': 122, 'desciption': 'Reserved for private use'},
  {'field': 123, 'desciption': 'Reserved for private use'},
  {'field': 124, 'desciption': 'Reserved for private use'},
  {'field': 125, 'desciption': 'Reserved for private use'},
  {'field': 126, 'desciption': 'Reserved for private use'},
  {'field': 127, 'desciption': 'Reserved for private use'},
  {'field': 128, 'desciption': 'Message authentication code'},
});

var ContentTypes1987 = new List<Map<String, dynamic>>.unmodifiable({
  {'field': 1, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 2, 'ContentType': 'n', 'MaxLen': 19, 'LenType': LT.LLVAR},
  {'field': 3, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED},
  {'field': 4, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 5, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 6, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 7, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 8, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 9, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 10, 'ContentType': 'n', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 11, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED},
  {'field': 12, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED},
  {'field': 13, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 14, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 15, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 16, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 17, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 18, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 19, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 20, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 21, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 22, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 23, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 24, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 25, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED},
  {'field': 26, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED},
  {'field': 27, 'ContentType': 'n', 'MaxLen': 1, 'LenType': LT.FIXED},
  {'field': 28, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED},
  {'field': 29, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED},
  {'field': 30, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED},
  {'field': 31, 'ContentType': 'an', 'MaxLen': 9, 'LenType': LT.FIXED},
  {'field': 32, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR},
  {'field': 33, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR},
  {'field': 34, 'ContentType': 'ns', 'MaxLen': 28, 'LenType': LT.LLVAR},
  {'field': 35, 'ContentType': 'z', 'MaxLen': 40, 'LenType': LT.LLVAR},
  {'field': 36, 'ContentType': 'n', 'MaxLen': 104, 'LenType': LT.LLLVAR},
  {'field': 37, 'ContentType': 'an', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 38, 'ContentType': 'an', 'MaxLen': 6, 'LenType': LT.FIXED},
  {'field': 39, 'ContentType': 'an', 'MaxLen': 2, 'LenType': LT.FIXED},
  {'field': 40, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 41, 'ContentType': 'ans', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 42, 'ContentType': 'ans', 'MaxLen': 15, 'LenType': LT.FIXED},
  {'field': 43, 'ContentType': 'ans', 'MaxLen': 40, 'LenType': LT.FIXED},
  {'field': 44, 'ContentType': 'an', 'MaxLen': 25, 'LenType': LT.LLVAR},
  {'field': 45, 'ContentType': 'an', 'MaxLen': 76, 'LenType': LT.LLVAR},
  {'field': 46, 'ContentType': 'an', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 47, 'ContentType': 'an', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 48, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 49, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 50, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 51, 'ContentType': 'an', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 52, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 53, 'ContentType': 'ans', 'MaxLen': 20, 'LenType': LT.FIXED},
  {'field': 54, 'ContentType': 'an', 'MaxLen': 120, 'LenType': LT.LLLVAR},
  {'field': 55, 'ContentType': 'b', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 56, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 57, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 58, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 59, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 60, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 61, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 62, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 63, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 64, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 65, 'ContentType': 'b', 'MaxLen': 1, 'LenType': LT.FIXED},
  {'field': 66, 'ContentType': 'n', 'MaxLen': 1, 'LenType': LT.FIXED},
  {'field': 67, 'ContentType': 'n', 'MaxLen': 2, 'LenType': LT.FIXED},
  {'field': 68, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 69, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 70, 'ContentType': 'n', 'MaxLen': 3, 'LenType': LT.FIXED},
  {'field': 71, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 72, 'ContentType': 'n', 'MaxLen': 4, 'LenType': LT.FIXED},
  {'field': 73, 'ContentType': 'n', 'MaxLen': 6, 'LenType': LT.FIXED},
  {'field': 74, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 75, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 76, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 77, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 78, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 79, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 80, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 81, 'ContentType': 'n', 'MaxLen': 10, 'LenType': LT.FIXED},
  {'field': 82, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 83, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 84, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 85, 'ContentType': 'n', 'MaxLen': 12, 'LenType': LT.FIXED},
  {'field': 86, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED},
  {'field': 87, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED},
  {'field': 88, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED},
  {'field': 89, 'ContentType': 'n', 'MaxLen': 16, 'LenType': LT.FIXED},
  {'field': 90, 'ContentType': 'n', 'MaxLen': 42, 'LenType': LT.FIXED},
  {'field': 91, 'ContentType': 'an', 'MaxLen': 1, 'LenType': LT.FIXED},
  {'field': 92, 'ContentType': 'an', 'MaxLen': 2, 'LenType': LT.FIXED},
  {'field': 93, 'ContentType': 'an', 'MaxLen': 5, 'LenType': LT.FIXED},
  {'field': 94, 'ContentType': 'an', 'MaxLen': 7, 'LenType': LT.FIXED},
  {'field': 95, 'ContentType': 'an', 'MaxLen': 42, 'LenType': LT.FIXED},
  {'field': 96, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED},
  {'field': 97, 'ContentType': 'an', 'MaxLen': 17, 'LenType': LT.FIXED},
  {'field': 98, 'ContentType': 'ans', 'MaxLen': 25, 'LenType': LT.FIXED},
  {'field': 99, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR},
  {'field': 100, 'ContentType': 'n', 'MaxLen': 11, 'LenType': LT.LLVAR},
  {'field': 101, 'ContentType': 'ans', 'MaxLen': 17, 'LenType': LT.LLVAR},
  {'field': 102, 'ContentType': 'ans', 'MaxLen': 28, 'LenType': LT.LLVAR},
  {'field': 103, 'ContentType': 'ans', 'MaxLen': 28, 'LenType': LT.LLVAR},
  {'field': 104, 'ContentType': 'ans', 'MaxLen': 100, 'LenType': LT.LLLVAR},
  {'field': 105, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 106, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 107, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 108, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 109, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 110, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 111, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 112, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 113, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 114, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 115, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 116, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 117, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 118, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 119, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 120, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 121, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 122, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 123, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 124, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 125, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 126, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 127, 'ContentType': 'ans', 'MaxLen': 999, 'LenType': LT.LLLVAR},
  {'field': 128, 'ContentType': 'b', 'MaxLen': 8, 'LenType': LT.FIXED}
});
