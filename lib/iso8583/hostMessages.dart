import 'dart:convert';
import 'dart:typed_data';

import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/utils/serialNumber.dart';
import 'package:pay/utils/dataUtils.dart';

Future<int> getStan() async {
  final appdb = DatabaseHelper.instance;

  Map<String, dynamic> counters = await appdb.queryById('counters', 1);
  return counters['stan'];
}

void incrementStan() async {
  final appdb = DatabaseHelper.instance;

  Map<String, dynamic> counters = await appdb.queryById('counters', 1);

  Map<String, dynamic> newCounter = {
    'id': 1,
    'stan': counters['stan'] + 1,
  };
  await appdb.update('counters', 1, newCounter);
}

String AddFiedl62Table(int table, String data) {
  String temp;
  String tableMsg = table.toString().padLeft(4, '0');
  switch (table) {
    case 41:
      String serial;
      temp = bcdToStr(AsciiEncoder().convert(tableMsg));
      if (data.length >= 16)
        serial = data.substring(data.length - 16, data.length).padRight(16, ' ');
      else
        serial = data.padRight(16, ' ');
      temp += bcdToStr(AsciiEncoder().convert(serial));
      break;
  }
  return (temp.length ~/ 2 - 2).toString().padLeft(4, '0') + temp;
}

class MessageInitialization {
  Comm _comm;
  Iso8583 message;
  int msgSeq = 0;

  MessageInitialization(this._comm) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    String sn = await SerialNumber.serialNumber;
    String field62;
    var isDev = (const String.fromEnvironment('dev') == 'true');

    field62 = AddFiedl62Table(41, sn);

    message.setMID(800);
    if (msgSeq == 0)
      message.fieldData(3, '9000' + msgSeq.toString().padLeft(2, '0'));
    else
      message.fieldData(3, '9001' + msgSeq.toString().padLeft(2, '0'));

    message.fieldData(11, (await getStan()).toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.TID);
    message.contentType(60, 'ans');
    message.fieldData(60, '01.00');
    message.fieldData(62, field62);

    msgSeq++;

    if (isDev) {
      message.printMessage();
    }

    return message.buildIso();
  }

  Map<int, String> parseRenponse(Uint8List response) {
    Iso8583 isoResponse = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
    Map respMap = new Map<int, String>();
    int i;
    Uint8List bitmap;
    var isDev = (const String.fromEnvironment('dev') == 'true');

    isoResponse.dataType(60, DT.BIN);
    isoResponse.dataType(61, DT.BIN);
    isoResponse.dataType(62, DT.BIN);

    isoResponse.setIsoContent(response);
    if (isDev) {
      isoResponse.printMessage();
    }

    bitmap = isoResponse.bitmap();

    for (i = 0; i < bitmap.length; i++) {
      if (bitmap[i] == 1) {
        respMap[i] = isoResponse.fieldData(i);
      }
    }

    return respMap;
  }
}
