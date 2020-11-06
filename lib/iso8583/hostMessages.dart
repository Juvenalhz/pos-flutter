import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/utils/pinpad.dart';
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

String addField62Table(int table, String data) {
  String temp;
  String tableMsg = table.toString().padLeft(2, '0');
  temp = bcdToStr(AsciiEncoder().convert(tableMsg));

  switch (table) {
    case 1:
      temp += bcdToStr(AsciiEncoder().convert(data.padLeft(4, '0')));
      break;
    case 2:
    case 3:
      temp += bcdToStr(AsciiEncoder().convert(data.padLeft(3, '0')));
      break;
    case 4:
      temp += bcdToStr(AsciiEncoder().convert(data.padRight(11, ' ')));
      break;
    case 18:
      temp += bcdToStr(AsciiEncoder().convert(data.padRight(2, ' ')));
      break;
    case 41:
      String serial;
      if (data.length >= 16)
        serial = data.substring(data.length - 16, data.length).padRight(16, ' ');
      else
        serial = data.padRight(16, ' ');
      temp += bcdToStr(AsciiEncoder().convert(serial));
      break;
  }
  return (temp.length ~/ 2).toString().padLeft(4, '0') + temp;
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

    field62 = addField62Table(41, sn);

    message.setMID(800);
    if (msgSeq == 0)
      message.fieldData(3, '9000' + msgSeq.toString().padLeft(2, '0'));
    else
      message.fieldData(3, '9001' + msgSeq.toString().padLeft(2, '0'));

    message.fieldData(11, (await getStan()).toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.tid);
    message.contentType(60, 'ans');
    //TODO: get the application version from the project
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

class TransactionMessage {
  Iso8583 message;
  Trans trans;
  Comm _comm;

  TransactionMessage(this.trans, this._comm) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    TerminalRepository terminalRepository = new TerminalRepository();
    TransRepository transRepository = new TransRepository();
    AcquirerRepository acquirerRepository = new AcquirerRepository();

    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(200);
    message.fieldData(3, '00' + trans.accType.toString() + '000');
    message.fieldData(4, trans.total.toString());
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(12, trans.dateTime.hour.toString() + trans.dateTime.minute.toString() + trans.dateTime.second.toString());
    message.fieldData(13, trans.dateTime.month.toString() + trans.dateTime.day.toString());
    message.fieldData(22, trans.entryMode.toString());
    if (trans.entryMode == Pinpad.CHIP) message.fieldData(23, trans.panSequenceNumber.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');
    message.fieldData(35, trans.track2);
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    if (trans.pinBlock.length > 0) message.fieldData(52, trans.pinBlock);
    if (trans.pinKSN.length > 0) message.fieldData(53, trans.pinKSN);
    if (trans.emvTags.length > 0) message.fieldData(55, trans.emvTags);
    message.fieldData(60, '01.00');

    field62 += addField62Table(1, trans.id.toString());
    field62 += addField62Table(2, merchant.batchNumber.toString());
    if (trans.cvv.length > 0) field62 += addField62Table(3, trans.cvv);
    if (trans.cardholderID.length > 0) field62 += addField62Table(4, trans.cardholderID);
    field62 += addField62Table(18, merchant.acquirerCode.toString());
    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

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
    //isoResponse.dataType(62, DT.BIN);

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

    //decode field 62
    i = 0;
    while (i < respMap[62].length) {
      int len = int.parse(respMap[62].substring(i, i + 4)) * 2;
      i += 4;
      int subTable = int.parse(ascii.decode(hex.decode(respMap[62].substring(i, i + 4))));
      i += 4;
      //add fields like 6201, 6202, ... 6241
      respMap[62 * 100 + subTable] = ascii.decode(hex.decode(respMap[62].substring(i, i + len - 4)));
      i += len - 4;
    }

    return respMap;
  }
}
