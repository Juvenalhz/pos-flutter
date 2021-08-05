import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/cipher.dart';
import 'package:pay/utils/constants.dart';
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

class HostMessage {
  Comm _comm;
  int _msgId;

  HostMessage(this._comm, this._msgId);

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
      case 5:
      case 13:
        temp += bcdToStr(AsciiEncoder().convert(data));
        break;
      case 18:
        temp += bcdToStr(AsciiEncoder().convert(data.padLeft(2, '0')));
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

  Future<Map<int, String>> parseRenponse(Uint8List response, {Trans trans}) async {
    Iso8583 isoResponse = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
    Map respMap = new Map<int, String>();
    int i;
    Uint8List bitmap;
    final bool isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    final bool isDev = (const String.fromEnvironment('dev') == 'true');

    if ((isDev == true) && (isCommOffline == true)) {
      MerchantRepository merchantRepository = new MerchantRepository();

      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

      if (trans != null) {
        respMap[4] = trans.total.toString();
        respMap[11] = trans.stan.toString();
      }
      respMap[37] = Random().nextInt(99999999).toString().padLeft(12, '0');
      respMap[38] = Random().nextInt(999999).toString().padLeft(6, '0');
      respMap[39] = '00';
      respMap[41] = merchant.tid.padLeft(8, '0');
    } else {
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

      //decode field 62
      i = 0;
      while ((respMap[62] != null) && (i < respMap[62].length)) {
        // List<int> sizeList = respMap[62].substring(i, i + 2).codeUnits;
        // Uint8List sizeBytes = Uint8List.fromList(sizeList);
        // int len = int.parse(bcdToStr(sizeBytes));
        // i += 2;
        // int subTable = int.parse(respMap[62].substring(i, i + 2));
        // i += 2;
        // //add fields like 6201, 6202, ... 6241
        // respMap[62 * 100 + subTable] = respMap[62].substring(i, i + len - 2);
        // i += len - 2;


        int len = int.parse(respMap[62].substring(i, i + 4)) * 2;
        i += 4;
        int subTable = int.parse(ascii.decode(hex.decode(respMap[62].substring(i, i + 4))));
        i += 4;
        //add fields like 6201, 6202, ... 6241
        respMap[62 * 100 + subTable] = ascii.decode(hex.decode(respMap[62].substring(i, i + len - 4)));
        i += len - 4;
      }
    }
    return respMap;
  }

  Uint8List calculateEFTSECChecksum(Uint8List message)
  {
    var checksum = Uint8List(1);

    checksum[0] = 0;

    message.forEach((element) {
      checksum[0] += element;
    });

    return checksum;
  }

  Future<Uint8List> buildCiphredMessage(Uint8List clearMessage) async {
    if (!(_comm.tpdu.contains('7000', 0)) || (_comm.kinIdTerminal == 0)){  //tpdu with value starting 7000 needs to use encryption

      memDump('request:', clearMessage);

      return clearMessage;
    }
    else {
      var cipher = Cipher();
      Uint8List temp;
      Uint8List cipheredData;
      int length;
      int clearLength;

      //create cyphered buffer
      if (_comm.headerLength == true) {
        clearLength = clearMessage.sublist(7).length;
        var lengthPadded = clearMessage.sublist(7).length + ( 8 - (clearMessage.sublist(7).length % 8));
        var tempBuffer = Uint8List (lengthPadded);
        var j = 0;
        clearMessage.sublist(7).forEach((element) {
          tempBuffer[j++] = element;
        });
        while (j<lengthPadded)
          tempBuffer[j++] = 0;
        cipheredData = await cipher.cipherMessage(tempBuffer, _comm.kinIdTerminal);
      }
      else {
        clearLength = clearMessage.sublist(5).length;
        var lengthPadded = clearMessage.sublist(5).length + ( 8 - (clearMessage.sublist(5).length % 8));
        var tempBuffer = Uint8List (lengthPadded);
        var j = 0;
        clearMessage.sublist(5).forEach((element) {
          tempBuffer[j++] = element;
        });
        while (j<lengthPadded)
          tempBuffer[j++] = 0;

        cipheredData = await cipher.cipherMessage(clearMessage.sublist(5), _comm.kinIdTerminal);
      }
      Uint8List dataToSend = new Uint8List(14 + cipheredData.length);  //length from the ciphered buffer + header of eftsec message

      int i = 0;
      int lengthIndex = 0;

      //leave space for full length
      if (_comm.headerLength == true) i += 2;

      //tpdu
      if (_comm.headerLength == true) {
        clearMessage.sublist(2, 7).forEach((element) {
          dataToSend[i++] = element;
        });
      }
      else {
        clearMessage.sublist(0, 5).forEach((element) {
          dataToSend[i++] = element;
        });
      }

      //kin
      temp = strToBcd(_comm.kin.toRadixString(16).padLeft(4, '0'));
      temp.forEach((element) {
        dataToSend[i++] = element;
      });

      //hex.decode(_comm.kin.toRadixString(16).padLeft(4, '0')).sublist(0).reversed.forEach((element) {dataToSend[i++] = element;});

      //start always 0x00 0x00
      [0, 0].forEach((element) {dataToSend[i++] = element;});

      //length of the request buffer in clear
      if (_comm.headerLength == true)
        length = clearLength; //temp = strToBcd((clearMessage.length - 2).toRadixString(16).padLeft(4, '0'));  // clear message has length added at this point, needs to be removed
      else
        length = clearLength; //temp = strToBcd(clearMessage.length.toRadixString(16).padLeft(4, '0'));

      temp = Uint8List(2)..buffer.asByteData().setInt16(0, length, Endian.big);
      temp.forEach((element) {
        dataToSend[i++] = element;
      });
      //hex.decode(clearMessage.length.toRadixString(16)).sublist(0).reversed.forEach((element) {dataToSend[i++] = element;});

      //checksum byte
      memDump('clar request:tha', clearMessage.sublist(7));
      dataToSend[i++] = calculateEFTSECChecksum(clearMessage.sublist(7))[0];

      //add ciphered data buffer
      cipheredData.forEach((element) {
        dataToSend[i++] = element;
      });

      //add full package length
      if (_comm.headerLength == true) {
        Uint8List temp = strToBcd((i - 2).toRadixString(16).padLeft(4, '0'));
        temp.forEach((element) {
          dataToSend[lengthIndex++] = element;
        });
      }

      memDump('Ciphred request', dataToSend);
      return dataToSend;
    }

  }
}

class MessageInitialization extends HostMessage {
  Comm _comm;
  Iso8583 message;
  int msgSeq = 0;
  int tableType = 0;
  int newTableType = 0;

  MessageInitialization(this._comm) : super(_comm, 800) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant;
    String sn = await SerialNumber.serialNumber;
    String field62;
    var isDev = (const String.fromEnvironment('dev') == 'true');

    field62 = addField62Table(41, sn);

    if (newTableType != 0) {
      _updateTableType();
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    }
    message.setMID(800);
    message.fieldData(3, '90' + tableType.toString().padLeft(2, '0') + msgSeq.toString().padLeft(2, '0'));
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(24, _comm.nii);
    if (tableType == 0)
      message.fieldData(41, '00000000');
    else
      message.fieldData(41, merchant.tid);
    message.fieldData(60, Constants.appVersionHost );
    message.fieldData(62, field62);

    msgSeq++;

    if (isDev) {
      message.printMessage();
    }
    message.dataType(60, DT.ASCII);
    return buildCiphredMessage(message.buildIso());

    //needed to process the response correctly
    message.dataType(60, DT.BIN);
  }

  Future<Map<int, String>> parseRenponse(Uint8List response, {Trans trans}) async {
    Map<int, String> respMap = await super.parseRenponse(response);

    newTableType = int.parse(respMap[3].substring(3, 4));
    if (respMap[3].substring(3, 4) != message.fieldData(3).substring(3,4))
      msgSeq = 1;

    return respMap;
  }

  void _updateTableType() {
    tableType = newTableType;
  }
}

class TransactionMessage extends HostMessage {
  Iso8583 message;
  Trans trans;
  Comm _comm;

  TransactionMessage(this.trans, this._comm) : super(_comm, 200) {
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
    if (trans.entryMode == Pinpad.MANUAL)
      message.fieldData(2, (trans.pan.length % 2 == 0) ? trans.pan : trans.pan.padRight(trans.pan.length + 1, 'F'));

    if (trans.binType == Bin.TYPE_FOOD)
      message.fieldData(3, '070000');
    else
      message.fieldData(3, '00' + trans.accType.toString() + '000');

    if(acquirer.industryType && trans.binType== Bin.TYPE_CREDIT)
      message.fieldData(4, trans.originalTotal.toString());
    else
      message.fieldData(4, trans.total.toString());

    message.fieldData(11, trans.stan.toString());

    if (trans.entryMode == Pinpad.MANUAL) message.fieldData(14, trans.expDate.substring(0, 4));

    message.fieldData(22, trans.entryMode.toString());
    if (trans.entryMode == Pinpad.CHIP) message.fieldData(23, trans.panSequenceNumber.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');

    if (trans.entryMode != Pinpad.MANUAL) message.fieldData(35, trans.track2);
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    if (trans.pinBlock.length > 0) message.fieldData(52, trans.pinBlock);
    if (trans.pinKSN.length > 0) message.fieldData(53, trans.pinKSN);
    if(acquirer.industryType && trans.binType== Bin.TYPE_CREDIT) message.fieldData(54, trans.tip.toString());
    if (trans.emvTags.length > 0) message.fieldData(55, trans.emvTags);

    message.fieldData(60, Constants.appVersionHost);

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

    return buildCiphredMessage(message.buildIso());
  }
}

class ReversalMessage extends HostMessage {
  Iso8583 message;
  Trans trans;
  Comm _comm;

  ReversalMessage(this.trans, this._comm) : super(_comm, 400) {
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
    String clearPan = '';
    trans.pan = await trans.getClearPan();

    message.setMID(400);
    message.fieldData(2, (trans.pan.length % 2 == 0) ? trans.pan : trans.pan.padRight(trans.pan.length + 1, 'F'));
    message.fieldData(3, '00' + trans.accType.toString() + '000');
    message.fieldData(4, trans.total.toString());
    message.fieldData(11, (await getStan()).toString());
    //message.fieldData(12, trans.dateTime.hour.toString() + trans.dateTime.minute.toString() + trans.dateTime.second.toString());
    //message.fieldData(13, trans.dateTime.month.toString() + trans.dateTime.day.toString());
    message.fieldData(14, trans.expDate.substring(0, 4));
    switch(trans.entryMode) {
      case Pinpad.MAG_STRIPE: message.fieldData(22, "021"); break;
      case Pinpad.CHIP: message.fieldData(22, "051"); break;
      case Pinpad.FALLBACK: message.fieldData(22, "921"); break;
      case Pinpad.MANUAL: message.fieldData(22, "011"); break;
    }
    if (trans.entryMode == Pinpad.CHIP) message.fieldData(23, trans.panSequenceNumber.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    if (trans.emvTags.length > 0) message.fieldData(55, trans.emvTags);
    message.fieldData(60, Constants.appVersionHost);

    field62 += addField62Table(1, trans.id.toString());
    field62 += addField62Table(2, merchant.batchNumber.toString());
    field62 += addField62Table(18, merchant.acquirerCode.toString());
    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class EchoTestMessage extends HostMessage {
  Iso8583 message;
  Comm _comm;

  EchoTestMessage(this._comm) : super(_comm, 400) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime dateTime = DateTime.now();

    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(800);
    message.fieldData(3, '990000');
    message.fieldData(
        7,
        dateTime.month.toString().padLeft(2, '0') +
            dateTime.day.toString().padLeft(2, '0') +
            dateTime.hour.toString().padLeft(2, '0') +
            dateTime.minute.toString().padLeft(2, '0') +
            dateTime.second.toString().padLeft(2, '0'));
    message.fieldData(11, (await getStan()).toString());
    //message.fieldData(12, dateTime.hour.toString() + dateTime.minute.toString() + dateTime.second.toString());
    //message.fieldData(13, dateTime.month.toString() + dateTime.day.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.tid);
    message.fieldData(60, Constants.appVersionHost);

    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class LastSaleMessage extends HostMessage {
  Iso8583 message;
  Comm _comm;

  LastSaleMessage(this._comm) : super(_comm, 400) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime dateTime = DateTime.now();

    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(100);
    message.fieldData(3, '340000');
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    message.fieldData(60, Constants.appVersionHost);

    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class VoidMessage extends HostMessage {
  Iso8583 message;
  Trans trans;
  Comm _comm;

  VoidMessage(this.trans, this._comm) : super(_comm, 200) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    TerminalRepository terminalRepository = new TerminalRepository();
    TransRepository transRepository = new TransRepository();
    AcquirerRepository acquirerRepository = new AcquirerRepository();
    String originalData;

    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
    Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(200);
    message.fieldData(3, '020000');
    message.fieldData(4, trans.total.toString());
    message.fieldData(11, (await getStan()).toString());
    //message.fieldData(12, trans.dateTime.hour.toString() + trans.dateTime.minute.toString() + trans.dateTime.second.toString());
    //message.fieldData(13, trans.dateTime.month.toString() + trans.dateTime.day.toString());
    message.fieldData(22, trans.entryMode.toString());
    //if (trans.entryMode == Pinpad.CHIP) message.fieldData(23, trans.panSequenceNumber.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');
    message.fieldData(35, trans.track2);
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    message.fieldData(60, Constants.appVersionHost);

    originalData = trans.referenceNumber.trim();
    originalData += trans.stan.toString().padLeft(6, '0');
    originalData += trans.authCode;
    originalData += trans.id.toString().padLeft(4, '0');
    field62 += addField62Table(1, trans.id.toString());
    field62 += addField62Table(2, merchant.batchNumber.toString());
    field62 += addField62Table(13, originalData);
    field62 += addField62Table(18, merchant.acquirerCode.toString());
    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class TechVisitMessage extends HostMessage {
  Iso8583 message;
  Comm _comm;

  TechVisitMessage(this._comm) : super(_comm, 800) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage(String track2, int visitType, int requirementType, String pinBlock, String pinKSN) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime dateTime = DateTime.now();
    String temp;
    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(800);
    message.fieldData(3, '970000');
    message.fieldData(
        7,
        dateTime.month.toString().padLeft(2, '0') +
            dateTime.day.toString().padLeft(2, '0') +
            dateTime.hour.toString().padLeft(2, '0') +
            dateTime.minute.toString().padLeft(2, '0') +
            dateTime.second.toString().padLeft(2, '0'));
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(35, track2);
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    if (pinBlock.length > 0) message.fieldData(52, pinBlock);
    if (pinKSN.length > 0) message.fieldData(53, pinKSN);
    message.fieldData(60, Constants.appVersionHost);

    temp = visitType.toString().padRight(2, ' ') + requirementType.toString().padRight(12, ' ');
    field62 += addField62Table(5, temp);
    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class AdjustMessage extends HostMessage {
  Iso8583 message;
  Trans trans;
  Comm _comm;

  AdjustMessage(this.trans, this._comm) : super(_comm, 200) {
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

    trans.pan = await trans.getClearPan();
    String sn = await SerialNumber.serialNumber;
    String originalData;

    message.setMID(220);
    message.fieldData(2, (trans.pan.length % 2 == 0) ? trans.pan : trans.pan.padRight(trans.pan.length + 1, 'F'));
    message.fieldData(3, '02' + trans.accType.toString() + '000');
    message.fieldData(4, trans.baseAmount.toString());
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(14, trans.expDate.substring(0, 4));
    message.fieldData(22, "0011");
    message.fieldData(24, _comm.nii);
    message.fieldData(25, '00');
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(49, merchant.currencyCode.toString());
    if(acquirer.industryType && trans.binType== Bin.TYPE_CREDIT) message.fieldData(54, trans.tip.toString());
    message.fieldData(60, Constants.appVersionHost);

    originalData = trans.referenceNumber.trim();
    originalData += trans.stan.toString().padLeft(6, '0');
    originalData += trans.authCode;
    originalData += trans.id.toString().padLeft(4, '0');
    field62 += addField62Table(2,merchant.batchNumber.toString());


    field62 += addField62Table(13, originalData);
    field62 += addField62Table(18, trans.acquirer.toString());
    field62 += addField62Table(41, sn);

    message.fieldData(62, field62);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}

class BatchMessage extends HostMessage {
  Iso8583 message;
  Comm _comm;
  int countSale;
  int totalSale;
  int countVoid;
  int totalVoid;
  int batchNumber;

  BatchMessage(this._comm, this.batchNumber, this.countSale, this.totalSale, this.countVoid, this.totalVoid) : super(_comm, 500) {
    message = new Iso8583(null, ISOSPEC.ISO_BCD, this._comm.tpdu, _comm.headerLength);
  }

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
    DateTime dateTime = DateTime.now();
    String field63;
    String field62 = '';
    var isDev = (const String.fromEnvironment('dev') == 'true');

    String sn = await SerialNumber.serialNumber;

    message.setMID(500);
    message.fieldData(3, '920000');
    message.fieldData(
        7,
        dateTime.month.toString().padLeft(2, '0') +
            dateTime.day.toString().padLeft(2, '0') +
            dateTime.hour.toString().padLeft(2, '0') +
            dateTime.minute.toString().padLeft(2, '0') +
            dateTime.second.toString().padLeft(2, '0'));
    message.fieldData(11, (await getStan()).toString());
    message.fieldData(15, dateTime.month.toString().padLeft(2, '0') + dateTime.day.toString().padLeft(2, '0'));
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.tid);
    message.fieldData(42, merchant.mid);
    message.fieldData(60, Constants.appVersionHost);

    field62 += addField62Table(41, sn);
    message.fieldData(62, field62);

    field63 = batchNumber.toString().padLeft(3, '0');
    field63 += countSale.toString().padLeft(4, '0') + totalSale.toString().padLeft(12, '0');
    field63 += (0).toString().padLeft(4, '0') + (0).toString().padLeft(12, '0');
    field63 += countVoid.toString().padLeft(4, '0') + totalVoid.toString().padLeft(12, '0');
    message.fieldData(63, field63);

    if (isDev) {
      message.printMessage();
    }

    //message.dataType(60, DT.ASCII);

    return buildCiphredMessage(message.buildIso());
  }
}
