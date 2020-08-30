import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/utils/communication.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(InitializationInitial());
  Comm comm;
  Comm newComm;
  Communication connection;
  MessageInitialization initialization;
  Uint8List response;
  int rxSize;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is InitializationConnect) {
      comm = event.comm;
      yield InitializationConnecting(comm);
      connection = new Communication(comm.ip, comm.port, false);
      await connection.connect();
      this.add(InitializationSend());
      yield InitializationSending();
    }
    else if (event is InitializationSend) {
      initialization = new MessageInitialization(comm);
      connection.sendMessage(await initialization.buildMessage());
      incrementStan();
      this.add(InitializationReceive());
      yield InitializationReceiving();
    }
    else if (event is InitializationReceive){
      if (connection.rxSize == 0)
        response = await connection.receiveMessage();
      if (connection.frameSize != 0)
      {
        MerchantRepository merchantRepository = new MerchantRepository();
        Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
        Map<int, String> respMap = initialization.parseRenponse(response);

        newComm = comm;
        if (respMap[43] != null)
          processField43(respMap[43], merchant);
        if (respMap[60] != null)
          processField60(respMap[60], merchant, newComm);
      }
      else
        this.add(InitializationReceive());

    }
    else {
      print(event);
    }
  }

  void processField43(String data, Merchant merchant) async {
    MerchantRepository merchantRepository = new MerchantRepository();

    merchant.NameL1 = data.substring(0, 20).trim();
    merchant.NameL2 = data.substring(20, 40).trim();
    merchant.City = data.substring(40, 60).trim();
    merchant.TaxID = data.substring(60, 73).trim();

    await merchantRepository.updateMerchant(merchant);
  }

  void processField60(String data, Merchant merchant, Comm comm) async {
    MerchantRepository merchantRepository = new MerchantRepository();

    merchant.MID = ascii.decode(hex.decode(data.substring(0, 30)));
    merchant.TID = data.substring(30, 32);
    merchant.CurrencyCode = int.parse(data.substring(32, 36));
    merchant.CurrencySymbol = ascii.decode(hex.decode(data.substring(36, 44)));
    merchant.AcquirerCode = data.substring(44, 46);

    comm.tpdu = data.substring(70, 80);
    comm.nii = data.substring(80, 84);
  }
}
