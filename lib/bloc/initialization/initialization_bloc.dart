import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/aid.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/pubkey.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/dataUtils.dart';
import 'package:pay/utils/datetime.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc extends Bloc<InitializationEvent, InitializationState> {
  InitializationBloc() : super(InitializationInitial());
  Comm comm;
  Comm newComm;
  Communication connection;
  MessageInitialization initialization;

  int rxSize;

  @override
  Stream<InitializationState> mapEventToState(
    InitializationEvent event,
  ) async* {
    if (event is InitializationConnect) {
      comm = event.comm;
      initialization = new MessageInitialization(comm);

      yield InitializationConnecting(comm);
      connection = new Communication(comm.ip, comm.port, false);
      await connection.connect();
      this.add(InitializationSend());
      yield InitializationSending();
    } else if (event is InitializationSend) {
      connection.sendMessage(await initialization.buildMessage());
      incrementStan();
      this.add(InitializationReceive());
      yield InitializationReceiving();
    } else if (event is InitializationReceive) {
      Uint8List response;
      if (connection.rxSize == 0) {
        response = await connection.receiveMessage();
      }
      if (connection.frameSize != 0) {
        MerchantRepository merchantRepository = new MerchantRepository();
        TerminalRepository terminalRepository = new TerminalRepository();
        EmvRepository emvRepository = new EmvRepository();
        Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
        Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
        Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
        Map<int, String> respMap = initialization.parseRenponse(response);

        if ((respMap[39] != null) && (respMap[39] == '00')) {
          newComm = comm;
          Map acquirerIndicators = new Map<int, String>();
          if (respMap[43] != null) {
            processField43(respMap[43], merchant);
          }
          if (respMap[60] != null) {
            processField60(respMap[60], merchant, newComm, terminal, emv, acquirerIndicators);
          }
          if ((respMap[3] != null) && (respMap[61] != null)) {
            if (respMap[3].substring(3, 4) == '1') {
              ProcessField61BIN(respMap[61]);
            } else if (respMap[3].substring(3, 4) == '2') {
              processField61AID(respMap[61]);
            } else if (respMap[3].substring(3, 4) == '3') {
              processField61PubKey(respMap[61]);
            }
          }
          if (respMap[62] != null) {
            processField62(respMap[62], merchant, acquirerIndicators);
          }

          if (respMap[3].substring(5, 6) == '1') {
            this.add(InitializationSend());
            yield InitializationSending();
          } else {
            connection.disconnect();
            yield InitializationCompleted();
          }
        } else {
          connection.disconnect();
          yield InitializationFailed();
        }
      } else
        this.add(InitializationReceive());
    } else {
      print(event);
    }
  }

  void processField43(String data, Merchant merchant) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    int index = 0;

    merchant.NameL1 = data.substring(index, index + 20).trim();
    index += 20;
    merchant.NameL2 = data.substring(index, index + 20).trim();
    index += 20;
    merchant.City = data.substring(index, index + 20).trim();
    index += 20;
    merchant.TaxID = data.substring(index, index + 13).trim();

    await merchantRepository.updateMerchant(merchant);
  }

  void processField60(String data, Merchant merchant, Comm comm, Terminal terminal, Emv emv, Map<int, String> acquirerIndicators) async {
    MerchantRepository merchantRepository = new MerchantRepository();
    SetDateTime newDateTime = new SetDateTime();
    int index = 0;

    merchant.MID = ascii.decode(hex.decode(data.substring(index, index + 30)));
    index += 30;
    merchant.TID = data.substring(index, index + 2);
    index += 2;
    merchant.CurrencyCode = int.parse(data.substring(index, index + 4));
    index += 4;
    merchant.CurrencySymbol = ascii.decode(hex.decode(data.substring(index, index + 8)));
    index += 8;
    merchant.AcquirerCode = data.substring(index, index + 2);
    index += 2 + 24; //phone numbers are skipped

    comm.tpdu = data.substring(index, index + 10);
    index += 10;
    comm.nii = data.substring(index, index + 4);
    index += 4;

    if ((int.parse(data.substring(index, index + 2)) & 0x01) != 0) terminal.amountConfirmation = 1;
    if ((int.parse(data.substring(index, index + 2)) & 0x02) != 0) emv.fallback = 1;
    if ((int.parse(data.substring(index, index + 2)) & 0x04) != 0) emv.forceOnline = 1;

    index += 2;
    //todo: extract aquirer parameters [86 - 122]
    acquirerIndicators.putIfAbsent(0, () => data.substring(index, index + 6));
    index += 6;
    acquirerIndicators.putIfAbsent(1, () => data.substring(index, index + 6));
    index += 6;
    acquirerIndicators.putIfAbsent(2, () => data.substring(index, index + 6));
    index += 6;
    acquirerIndicators.putIfAbsent(3, () => data.substring(index, index + 6));
    index += 6;
    acquirerIndicators.putIfAbsent(4, () => data.substring(index, index + 6));
    index += 6;
    acquirerIndicators.putIfAbsent(0, () => data.substring(index, index + 6));
    index += 6;

    terminal.techPassword = ascii.decode(hex.decode(data.substring(index, index + 8)));
    index += 8;
    terminal.maxTipPercentage = int.parse(data.substring(index, index + 2));
    index += 2;
    newComm.timeout = int.parse(data.substring(index, index + 4));
    index += 4;
    terminal.timeoutPrompt = int.parse(data.substring(index, index + 4));
    index += 4;

    String dateAndTime = data.substring(index, index + 12);
    newDateTime.dateTime = dateAndTime;

    index += 12;
    merchant.CountryCode = int.parse(data.substring(index, index + 4));
  }

  void ProcessField61BIN(String data) async {
    BinRepository binRepository = new BinRepository();
    var bin = new Bin();
    int index = 0;

    while (index < data.length) {
      bool addBin = false;
      bool binExist;

      addBin = (ascii.decode(hex.decode(data.substring(index, index + 2))) == 'A');
      index += 2;
      bin.type = ascii.decode(hex.decode(data.substring(index, index + 2)));
      index += 2;
      bin.binLow = int.parse(data.substring(index, index + 8));
      index += 8;
      bin.binHigh = int.parse(data.substring(index, index + 8));
      index += 8;
      bin.cardType = int.parse(data.substring(index, index + 2));
      index += 2;
      bin.brand = ascii.decode(hex.decode(data.substring(index, index + 24))).trim();
      index += 24;
      bin.cashback = int.parse(ascii.decode(hex.decode(data.substring(index, index + 2))));
      index += 2;
      bin.pin = int.parse(ascii.decode(hex.decode(data.substring(index, index + 2))));
      index += 2;
      bin.manualEntry = int.parse(ascii.decode(hex.decode(data.substring(index, index + 2))));
      index += 2;
      bin.fallback = int.parse(ascii.decode(hex.decode(data.substring(index, index + 2))));
      index += 2;

      binExist = await binRepository.existBin(bin);
      if ((addBin) && (!binExist)) {
        await binRepository.createBin(bin);
      } else if ((!addBin) && (binExist)) {
        await binRepository.deleteBin(bin);
      }
    }
  }

  void processField61AID(String data) async {
    AidRepository aidRepository = new AidRepository();
    var aid = new AID();
    int index = 0;

    while (index < data.length) {
      bool addAid = false;
      bool aidExist;

      addAid = (ascii.decode(hex.decode(data.substring(index, index + 2))) == 'A');
      index += 2;
      aid.aid = ascii.decode(hex.decode(data.substring(index, index + 32))).trim();
      index += 32;
      aid.floorLimit = int.parse(data.substring(index, index + 12));
      index += 12;
      aid.version = int.parse(data.substring(index, index + 4), radix: 16);
      index += 4;
      aid.tacDenial = data.substring(index, index + 10);
      index += 10;
      aid.tacOnline = data.substring(index, index + 10);
      index += 10;
      aid.tacDefault = data.substring(index, index + 10);
      index += 10;
      aid.exactMatch = int.parse(ascii.decode(hex.decode(data.substring(index, index + 2))));
      index += 2;
      aid.thresholdAmount = int.parse(data.substring(index, index + 12));
      index += 12;
      aid.targetPercentage = int.parse(data.substring(index, index + 2));
      index += 2;
      aid.maxTargetPercentage = int.parse(data.substring(index, index + 2));
      index += 2;
      aid.tdol = ascii.decode(hex.decode(data.substring(index, index + 64))).trim();
      index += 64;
      aid.ddol = ascii.decode(hex.decode(data.substring(index, index + 64))).trim();
      index += 64;

      aidExist = await aidRepository.existAid(aid);
      if ((addAid) && (!aidExist)) {
        await aidRepository.createAid(aid);
      } else if ((!addAid) && (aidExist)) {
        await aidRepository.deleteAid(aid);
      }
    }
  }

  void processField61PubKey(String data) async {
    PubKeyRepository pubkeyRepository = new PubKeyRepository();
    var pubkey = new PubKey();
    int index = 0;

    while (index < data.length) {
      bool addPubKey = false;
      bool pubKeyExist;

      addPubKey = (ascii.decode(hex.decode(data.substring(index, index + 2))) == 'A');
      index += 2;
      pubkey.keyIndex = int.parse(ascii.decode(hex.decode(data.substring(index, index + 4))), radix: 16);
      index += 4;
      pubkey.rid = data.substring(index, index + 10);
      index += 10;
      pubkey.exponent = data.substring(index, index + 2);
      index += 2;
      pubkey.expDate = data.substring(index, index + 6);
      index += 6;
      pubkey.length = int.parse(data.substring(index, index + 4));
      index += 4;
      pubkey.modulus = data.substring(index, index + (pubkey.length * 2));
      index += (pubkey.length * 2);

      pubKeyExist = await pubkeyRepository.existPubKey(pubkey);
      if ((addPubKey) && (!pubKeyExist)) {
        await pubkeyRepository.createPubKey(pubkey);
      } else if ((!addPubKey) && (pubKeyExist)) {
        await pubkeyRepository.deletePubKey(pubkey);
      }
    }
  }

  void processField62(String data, Merchant merchant, Map<int, String> acquirerIndicator) async {
    int index = 0;
    int size;
    int table;
    int i;
    int j = 0;
    String tableData;

    while (index < data.length) {
      i = 0;
      size = int.parse(data.substring(index, index + 4));
      index += 4;

      table = int.parse(ascii.decode(hex.decode(data.substring(index, index + 4))));
      index += 4;

      tableData = data.substring(index, index + (size - 2) * 2);
      index += tableData.length;

      switch (table) {
        case 2:
          {
            merchant.BatchNumber = int.parse(ascii.decode(hex.decode(tableData)));
          }
          break;
        case 7:
          {
            AcquirerRepository acquirerRepository = new AcquirerRepository();
            while (i < tableData.length) {
              Acquirer acquirer = new Acquirer(0, '', '');
              acquirer.id = int.parse(ascii.decode(hex.decode(tableData.substring(i, i + 4))));
              i += 4;
              acquirer.name = ascii.decode(hex.decode(tableData.substring(i, i + 40)));
              i += 40;
              acquirer.rif = ascii.decode(hex.decode(tableData.substring(i, i + 26)));
              i += 26;

              await acquirerRepository.deleteacquirer(acquirer.id);
              await acquirerRepository.createacquirer(acquirer);
            }
          }
          break;
      }
    }
  }
}
