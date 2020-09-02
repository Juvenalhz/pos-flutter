import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/dataUtils.dart';

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

        newComm = comm;
        if (respMap[43] != null) {
          processField43(respMap[43], merchant);
        }
        if (respMap[60] != null) {
          processField60(respMap[60], merchant, newComm, terminal, emv);
        }
        if (respMap[61] != null) {
          if ((respMap[3] != null) && (respMap[3].substring(3, 4) == '1')) {
            ProcessField61BIN(respMap[61]);
          }
        }
        if (respMap[62] != null) processField62(respMap[62], merchant);

        if (respMap[3].substring(5, 6) == '1') {
          this.add(InitializationSend());
          yield InitializationSending();
        }
      } else
        this.add(InitializationReceive());
    } else {
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

  void processField60(String data, Merchant merchant, Comm comm, Terminal terminal, Emv emv) async {
    MerchantRepository merchantRepository = new MerchantRepository();

    merchant.MID = ascii.decode(hex.decode(data.substring(0, 30)));
    merchant.TID = data.substring(30, 32);
    merchant.CurrencyCode = int.parse(data.substring(32, 36));
    merchant.CurrencySymbol = ascii.decode(hex.decode(data.substring(36, 44)));
    merchant.AcquirerCode = data.substring(44, 46);

    comm.tpdu = data.substring(70, 80);
    comm.nii = data.substring(80, 84);

    if ((int.parse(data.substring(84, 86)) & 0x01) != 0) terminal.amountConfirmation = 1;
    if ((int.parse(data.substring(84, 86)) & 0x02) != 0) emv.fallback = 1;
    if ((int.parse(data.substring(84, 86)) & 0x04) != 0) emv.forceOnline = 1;

    //todo: extract aquirer parameters [86 - 122]

    terminal.password = ascii.decode(hex.decode(data.substring(122, 130)));
    terminal.maxTipPercentage = int.parse(data.substring(130, 132));
    newComm.timeout = int.parse(data.substring(132, 136));
    String test2 = data.substring(136, 140);
    terminal.timeoutPrompt = int.parse(data.substring(136, 140));

    //todo: call android channel to set the date and time of the device
    String dateAndTime = data.substring(140, 152);
    merchant.CountryCode = int.parse(data.substring(152, 156));
  }

  void ProcessField61BIN(String data) async {
    BinRepository binRepository = new BinRepository();
    var bin = new Bin();
    int index = 0;

    while (index < data.length) {
      bin.type = ascii.decode(hex.decode(data.substring(index + 2, index + 4)));
      bin.binLow = int.parse(data.substring(index + 4, index + 12));
      bin.binHigh = int.parse(data.substring(index + 12, index + 20));
      bin.cardType = int.parse(data.substring(index + 20, index + 22));
      bin.brand = ascii.decode(hex.decode(data.substring(index + 22, index + 46))).trim();
      bin.cashback = int.parse(ascii.decode(hex.decode(data.substring(index + 46, index + 48))));
      bin.pin = int.parse(ascii.decode(hex.decode(data.substring(index + 48, index + 50))));
      bin.manualEntry = int.parse(ascii.decode(hex.decode(data.substring(index + 50, index + 52))));
      bin.fallback = int.parse(ascii.decode(hex.decode(data.substring(index + 52, index + 54))));
      index += 54;
    }
  }

  void processField62(String data, Merchant merchant) async {
    int index = 0;
    int size;
    int table;
    int i;
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
