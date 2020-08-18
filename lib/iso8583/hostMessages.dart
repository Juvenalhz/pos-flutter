import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/merchant/merchant_bloc.dart';
import 'package:pay/bloc/merchant/merchant_state.dart';
import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/utils/serialNumber.dart';

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

  Future<Uint8List> buildMessage() async {
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

    String sn = await SerialNumber.serialNumber;

    message.setMID(800);
    message.fieldData(3, '9001' + msgSeq.toString().padLeft(2, '0'));
    message.fieldData(11, stan.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.TID);
    message.fieldData(60, '01.00');
    message.fieldData(62, sn);

    //message.printMessage();

    return message.buildIso();
  }
}
