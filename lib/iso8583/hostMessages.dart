import 'dart:typed_data';

import 'package:pay/iso8583/8583.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';

class MessageInitialization {
  Comm _comm;
  Iso8583 message;
  Uint8List isoBuffer;
  int msgSeq = 0;
  int stan;

  MessageInitialization(this._comm){
    message = new Iso8583(null, ISOSPEC.ISO_BCD);
  }

  void setStan(int stan){
    this.stan = stan;
  }

  Future<Uint8List> buildMessage() async{
    MerchantRepository merchantRepository = new MerchantRepository();
    Merchant merchant = await merchantRepository.getMerchant(1);

    message.setMID(800);
    message.fieldData(3, '9001' + msgSeq.toString().padLeft(2, '0'));
    message.fieldData(11, stan.toString());
    message.fieldData(24, _comm.nii);
    message.fieldData(41, merchant.TID);
    message.fieldData(60, '01.00');
    message.fieldData(62, '1234567890123456');

    isoBuffer = message.buildIso();
    return isoBuffer;
  }
}