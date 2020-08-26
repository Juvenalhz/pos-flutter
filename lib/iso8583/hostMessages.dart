import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/merchant/merchant_bloc.dart';
import 'package:pay/bloc/merchant/merchant_state.dart';
import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/utils/serialNumber.dart';
import 'package:pay/utils/dataUtils.dart';

String AddFiedl62Table(int table, String data) {
  String temp;
  String tableMsg = table.toString().padLeft(4, '0');
  switch (table) {
    case 41:
      temp = bcdToStr(AsciiEncoder().convert(tableMsg));
      temp += bcdToStr(AsciiEncoder().convert(data.substring(data.length - 16, data.length).padRight(16, ' ')));
      break;
  }
  return (temp.length ~/ 2 - 2).toString().padLeft(4, '0') + temp;
}

class MessageInitialization {
  Comm _comm;
  Iso8583 message;
  int msgSeq = 0;
  int stan = 0;

  MessageInitialization(this._comm) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, (_comm.headerLength != 0) ? true : false);
  }

  void setStan(int stan) {
    this.stan = stan;
  }

  Future<Uint8List> buildMessage1() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    String sn = await SerialNumber.serialNumber;
    String field62;

    field62 = AddFiedl62Table(41, sn);

    message.setMID(800);
    message.fieldData(3, '9000' + msgSeq.toString().padLeft(2, '0'));
    message.fieldData(11, stan.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.TID);
    message.fieldData(60, '01.00');
    message.fieldData(62, field62);

    msgSeq++;
    message.printMessage();

    return message.buildIso();
  }

  Future<Uint8List> buildMessage2() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    String sn = await SerialNumber.serialNumber;
    String field62;

    field62 = AddFiedl62Table(41, sn);

    message.setMID(800);
    message.fieldData(3, '9001' + msgSeq.toString().padLeft(2, '0'));
    message.fieldData(11, stan.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.TID);
    message.fieldData(60, '01.00');
    message.fieldData(62, field62);

    msgSeq++;
    message.printMessage();

    return message.buildIso();
  }

  Map<int, String> parseRenponse(Uint8List response) {
    Iso8583 isoResponse = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, (_comm.headerLength != 0) ? true : false);;
    Map respMap = new Map<int, String>();
    int i;
    Uint8List bitmap;

    isoResponse.setIsoContent(response);
    isoResponse.printMessage();
    bitmap = isoResponse.bitmap();

    for (i=0; i < bitmap.length; i++) {
      if (bitmap[i] == 1) {
        print(isoResponse.fieldData(i));
        respMap[i] = isoResponse.fieldData(i);
      }
    }

    return respMap;
  }
}
