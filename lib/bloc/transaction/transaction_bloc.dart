import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/aid.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/utils/dataUtils.dart';
import 'package:pay/utils/receipt.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  Pinpad pinpad;
  var trans = new Trans();
  var originalTrans = new Trans();
  BuildContext context;
  bool emvTablesInit = false;
  static Communication connection;
  TransactionMessage message;
  ReversalMessage reversalMessage;
  VoidMessage voidMessage;
  TransRepository transRepository = new TransRepository();
  TerminalRepository terminalRepository = new TerminalRepository();
  CommRepository commRepository = new CommRepository();
  MerchantRepository merchantRepository = new MerchantRepository();
  AcquirerRepository acquirerRepository = new AcquirerRepository();
  Merchant merchant;
  Acquirer acquirer;
  bool doBeep = false;

  TransactionBloc(this.context) : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    print(event.toString());

    if (event is TransactionInitial) {
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

      yield TransactionAddAmount(trans);
    } else if (event is TransInitPinpad) {
      pinpad = event.pinpad;
    }
    // read base amount
    else if (event is TransStartTransaction) {
      await new Future.delayed(const Duration(seconds: 3));
      yield TransactionAddAmount(trans);
    }
    // base amount added, transaction initial data
    else if (event is TransAddAmount) {
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

      trans.id = (await transRepository.getMaxId()) + 1;
      trans.baseAmount = event.amount;
      trans.total = event.amount;
      trans.type = 'Venta';
      trans.stan = await getStan();
      trans.acquirer = merchant.acquirerCode;

      if (acquirer.industryType) // true = restaurant
        yield TransactionAddTip(trans);
      else
        this.add(TransAddTip(0)); // skip tip prompt
    }
    // going back to the base amount entry
    else if (event is TransAskAmount) {
      trans.baseAmount = event.amount;
      trans.tip = 0;
      yield TransactionAddAmount(trans);
    }
    // add tip amount to the transaction
    else if (event is TransAddTip) {
      trans.tip = event.tip;
      trans.total += event.tip;
      trans.dateTime = DateTime.now();
      if (emvTablesInit == false) {
        this.add(TransLoadEmvTables(this.pinpad));
        emvTablesInit = true;
      } else
        this.add(TransGetCard());
    }
    // going back to the tip amount screen
    else if (event is TransAskTip) {
      trans.tip = event.tip;
      yield TransactionAddTip(trans);
    }
    // start void transaction for the id
    else if (event is TransVoidTransaction) {
      merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));
      originalTrans = Trans.fromMap(await transRepository.getTrans(event.id));
      trans = Trans.fromMap(originalTrans.toMap());

      if (trans.type == 'Venta') trans.type = 'Anulación';
      trans.dateTime = DateTime.now();

      if (emvTablesInit == false) {
        this.add(TransLoadEmvTables(this.pinpad));
        emvTablesInit = true;
      } else
        this.add(TransGetCard());
    }
    // configure EMV parameters to pinpad module
    else if (event is TransLoadEmvTables) {
      EmvRepository emvRepository = new EmvRepository();
      AidRepository aidRepository = new AidRepository();
      PubKeyRepository pubKeyRepository = new PubKeyRepository();
      Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
      List<Map<String, dynamic>> aids = await aidRepository.getAids();
      //TODO: discard expired public keys
      List<Map<String, dynamic>> pubKeys = await pubKeyRepository.getPubKeys();
      pinpad = event.pinpad;
      pinpad.loadTables(emv.toMap(), aids, pubKeys);
      this.add(TransWaitEmvTablesLoaded());
      yield TransactionWaitEmvTablesLoaded();
    }
    // show message callback during emv flow
    else if (event is TransShowMessage) {
      yield TransactionShowMessage(event.message);
    }
    // read card from pinpad
    else if (event is TransGetCard) {
      if (await pinpad.getCard(trans.toMap()) != 0) {
        trans.clear();
        yield TransactionError();
      }
    }
    // card was read, save data returned by pinpad module
    else if (event is TransCardWasRead) {
      if (event.card['serviceCode'] != null) trans.serviceCode = event.card['serviceCode'];
      if (event.card['appType'] != null) trans.appType = event.card['appType'];
      if (event.card['cardType'] != null) trans.cardType = event.card['cardType'];
      if (event.card['entryMode'] != null) trans.entryMode = event.card['entryMode'];
      if (event.card['PANSequenceNumber'] != null) trans.panSequenceNumber = event.card['PANSequenceNumber'];
      if (event.card['cardholderName'] != null) trans.cardholderName = event.card['cardholderName'];
      if (event.card['pan'] != null) {
        trans.pan = event.card['pan'];
        trans.maskedPAN = trans.pan.substring(0, 4) + '....' + trans.pan.substring(trans.pan.length - 4);
      }
      if (event.card['track1'] != null) trans.track1 = event.card['track1'];
      if (event.card['track2'] != null) trans.track2 = event.card['track2'];
      if (event.card['expDate'] != null) trans.expDate = event.card['expDate'];
      if (event.card['appLabel'] != null) trans.appLabel = event.card['appLabel'];
      if (event.card['recordID'] != null) trans.aidID = event.card['recordID'];

      yield TransactionCardRead(trans);
      this.add(TransProcessCard(trans));
    }
    // card analisys (BIN, Debit/Credit)
    else if (event is TransProcessCard) {
      int binId = await _validateBin(event.trans.pan);
      if (binId == 0) {
        yield TransactionShowMessage(("BIN Invalido"));
        trans.clear();
        await new Future.delayed(const Duration(seconds: 3));
        yield TransactionError();
      } else {
        trans = event.trans;
        trans.bin = binId;
        if (event.trans.cardType == Pinpad.MAG_STRIPE) {
          if (acquirer.last4Digits)
            yield TransactionAskLast4Digits();
          else if (acquirer.cvv2) {
            if (trans.type == 'Venta')
              yield TransactionAskCVV();
            else
              yield TransactionAskConfirmation(trans, acquirer);
          } else {
            if (trans.type == 'Venta')
              yield TransactionAskIdNumber();
            else
              yield TransactionAskConfirmation(trans, acquirer);
          }
        } else {
          if (_validateChipData(trans) == true) {
            if (trans.type == 'Venta')
              yield TransactionAskIdNumber();
            else
              yield TransactionAskConfirmation(trans, acquirer);
          } else {
            yield TransactionShowMessage(("Error en Tarjeta"));
            trans.clear();
            await new Future.delayed(const Duration(seconds: 3));
            yield TransactionError();
          }
        }
      }
    }
    // last 4 digits entered need to match
    else if (event is TransAddLast4) {
      if (trans.pan.substring(trans.pan.length - 4) == event.last4.toString()) {
        if (acquirer.cvv2) {
          if (trans.type == 'Venta')
            yield TransactionAskCVV();
          else
            yield TransactionAskConfirmation(trans, acquirer);
        } else
          yield TransactionAskIdNumber();
      } else {
        yield TransactionShowMessage('Ultimos 4 Digitos No Coinciden, Intente Nuevamente');
        await new Future.delayed(const Duration(seconds: 3));
        yield TransactionAskLast4Digits();
      }
    }
    // back key was clicked at last4 screen, will go back to enter card
    else if (event is TransLast4Back) {
      this.add(TransGetCard());
    }
    // cvv was entered
    else if (event is TransAddCVV) {
      trans.cvv = event.cvvNumber.toString();
      yield TransactionAskIdNumber();
    }
    // back key was clicked at cvv screen, will go back to enter last4
    else if (event is TransCVVBack) {
      if (acquirer.last4Digits)
        yield TransactionAskLast4Digits();
      else
        this.add(TransGetCard());
    }
    //
    else if (event is TransAskIdNumber) {
      yield TransactionAskIdNumber();
    }
    // back key was cliecked at the entry id screen
    else if (event is TransIDBack) {
      if (acquirer.cvv2)
        yield TransactionAskCVV();
      else if (acquirer.last4Digits)
        yield TransactionAskLast4Digits();
      else
        this.add(TransGetCard());
    }
    // cardhoder id entered
    else if (event is TransAddIdNumber) {
      BinRepository binRepository = new BinRepository();
      Bin bin = Bin.fromMap(await binRepository.getBin(trans.bin));

      trans.binType = bin.cardType;
      trans.cardholderID = event.idNumber.toString();

      trans.binType = Bin.TYPE_CREDIT;
      if (trans.binType == Bin.TYPE_CREDIT) {
        acquirer.industryType = true;
        if (acquirer.industryType) // true = restaurant
          yield TransactionAskServerNumber();
        else
          yield TransactionAskConfirmation(trans, acquirer);
      } else {
        yield TransactionAskAccountType();
      }
    } else if (event is TransAddServerNumber) {
      trans.server = event.server;
      yield TransactionAskConfirmation(trans, acquirer);
    } else if (event is TransServerBack) {
      trans.server = 0;
      yield TransactionAskIdNumber();
    }
    // account type ase selected
    else if (event is TransAddAccountType) {
      trans.accType = event.accType;

      if ((trans.accType > 0) && (trans.pinBlock.length == 0)) {
        Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));

        yield TransactionShowPinAmount(trans);
        await pinpad.askPin(terminal.keyIndex, trans.pan, '', ''); // parameter 3 and 4 are not shown by the BC library
      } else
        yield TransactionAskConfirmation(trans, acquirer);
    }
    // online pin was entered for swiped cases
    else if (event is TransPinEntered) {
      if (event.pinData['PINBlock'] != null) {
        trans.pinBlock = event.pinData['PINBlock'];
        trans.onlinePIN = true;
      }
      if (event.pinData['PINKSN'] != null) trans.pinKSN = event.pinData['PINKSN'];
      yield TransactionAskConfirmation(trans, acquirer);
    }
    // continue chip card emv flow, will perform risk analisys, pin entry, online/offline decision
    else if (event is TransGoOnChip) {
      AidRepository aidRepository = new AidRepository();
      AID aid = AID.fromMap(await aidRepository.getAid(trans.aidID));
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));

      if (await pinpad.goOnChip(trans.toMap(), terminal.toMap(), aid.toMap()) == 0) {
        yield TransactionFinshChip();
      } else {
        trans.clear();
        yield TransactionError();
      }
    }
    // show message on screen while pinpad module ask for pin
    else if (event is TransShowPinAmount) {
      yield TransactionShowPinAmount(trans);
    } else if (event is TransConfirmOK) {
      trans.originalTotal = trans.total;
      if (trans.cardType == Pinpad.CHIP) {
        this.add(TransGoOnChip(trans));
      } else {
        this.add(TransOnlineTransaction(trans));
      }
    }
    // analyze chip desition online/offline/decline by chip
    else if (event is TransGoOnChipDecision) {
      if (event.chipDoneData['decision'] != null) trans.cardDecision = event.chipDoneData['decision'];
      if (event.chipDoneData['signature'] != null) trans.signature = intToBool(event.chipDoneData['signature']);
      if (event.chipDoneData['OfflinePIN'] != null) trans.offlinePIN = intToBool(event.chipDoneData['OfflinePIN']);
      if (event.chipDoneData['triesLeft'] != null) trans.triesLeft = event.chipDoneData['triesLeft'];
      if (event.chipDoneData['BlockedPIN'] != null) trans.blockedPIN = intToBool(event.chipDoneData['BlockedPIN']);
      if (event.chipDoneData['OnlinePIN'] != null) trans.onlinePIN = intToBool(event.chipDoneData['OnlinePIN']);
      if (event.chipDoneData['PINBlock'] != null) trans.pinBlock = event.chipDoneData['PINBlock'];
      if (event.chipDoneData['PINKSN'] != null) trans.pinKSN = event.chipDoneData['PINKSN'];
      if (event.chipDoneData['emvTags'] != null) trans.emvTags = event.chipDoneData['emvTags'];

      if (trans.cardDecision == 1) {
        // denial by the card
        yield TransactionShowMessage('Transaccion Rechazada Por Tarjeta');
        await new Future.delayed(const Duration(seconds: 3));
        trans.clear();
        yield TransactionError();
      } else if (trans.cardDecision == 0) {
        // this case is offline approval
      } else
        this.add(TransOnlineTransaction(trans));
    }
    // start online process
    else if (event is TransOnlineTransaction) {
      this.add(TransConnect());
    }
    // Connect
    else if (event is TransConnect) {
      Comm comm = Comm.fromMap(await commRepository.getComm(1));
      connection = new Communication(comm.ip, comm.port, true, comm.timeout);

      yield TransactionConnecting();

      if ((isDev == true) && (isCommOffline == true))
        this.add(TransSendReversal());
      else if (await connection.connect() == true) {
        this.add(TransSendReversal());
      } else {
        yield TransactionCommError();
      }
    }
    // reversal request
    else if (event is TransSendReversal) {
      if (await transRepository.getCountReversal() != 0) {
        Trans transReversal = Trans.fromMap(await transRepository.getTransReversal());
        Comm comm = Comm.fromMap(await commRepository.getComm(1));

        reversalMessage = new ReversalMessage(transReversal, comm);

        if ((isDev == true) && (isCommOffline == true))
          await reversalMessage.buildMessage();
        else
          connection.sendMessage(await reversalMessage.buildMessage());

        this.add(TransReceiveReversal(transReversal));
      } else
        this.add(TransSendRequest());
    }
    // reversal response
    else if (event is TransReceiveReversal) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response == null) {
        trans.clear();
        yield TransactionShowMessage('Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        yield TransactionError();
      } else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await reversalMessage.parseRenponse(response, trans: trans);
        if (respMap[39] == '00') {
          await transRepository.deleteTrans(event.transReversal.id);
          this.add(TransSendRequest());
        } else // error in reversal
          yield TransactionError();
      }
    }
    // send request
    else if (event is TransSendRequest) {
      Comm comm = Comm.fromMap(await commRepository.getComm(1));

      yield TransactionSending();
      if (trans.type == 'Venta') {
        message = new TransactionMessage(trans, comm);
        if ((isDev == true) && (isCommOffline == true))
          await message.buildMessage();
        else
          connection.sendMessage(await message.buildMessage());
      } else {
        voidMessage = new VoidMessage(trans, comm);
        if ((isDev == true) && (isCommOffline == true))
          await voidMessage.buildMessage();
        else
          connection.sendMessage(await voidMessage.buildMessage());
      }

      trans.stan = await getStan();
      // save reversal
      if (trans.type == 'Venta') {
        trans.reverse = true;
        await transRepository.createTrans(trans);
        trans.reverse = false;
      }
      incrementStan();
      this.add(TransReceive());
    }
    // received response message and parse it
    else if (event is TransReceive) {
      Uint8List response;
      yield TransactionReceiving();

      if (isCommOffline == false) {
        response = await connection.receiveMessage();
        if (response == null) {
          trans.clear();
          yield TransactionShowMessage('Error - Timeout de comunicación');
          await new Future.delayed(const Duration(seconds: 3));
          yield TransactionError();
        }
      }
      if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap;

        if (trans.type == 'Venta')
          respMap = await message.parseRenponse(response, trans: trans);
        else
          respMap = await voidMessage.parseRenponse(response, trans: trans);

        this.add(TransProcessResponse(respMap));
      }
      connection.disconnect();
    }
    // analyze response fields
    else if (event is TransProcessResponse) {
      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

      if ((event.respMap[4] == null) ||
          (trans.total != int.parse(event.respMap[4])) ||
          (event.respMap[11] == null) ||
          (trans.stan != int.parse(event.respMap[11])) ||
          (event.respMap[41] == null) ||
          (merchant.tid.padLeft(8, '0') != event.respMap[41])) {
        // reversal is stored in the DB
        trans.respMessage = 'Error En Respuesta';
        yield TransactionRejected(trans);
      } else {
        if (event.respMap[39] != null) trans.respCode = event.respMap[39];

        if (trans.respCode == '00') {
          if (event.respMap[37] != null) trans.referenceNumber = event.respMap[37];
          if (event.respMap[38] != null) trans.authCode = event.respMap[38];
          if (event.respMap[55] != null) trans.responseEmvTags = event.respMap[55];

          if (trans.cardType == Pinpad.CHIP) {
            this.add(TransFinishChip(trans));
          } else {
            if (trans.type == 'Venta')
              transRepository.updateTrans(trans);
            else {
              //update original transaaction
              originalTrans.voided = true;
              transRepository.updateTrans(originalTrans);
              //add void to database
              trans.id = (await transRepository.getMaxId()) + 1;
              transRepository.createTrans(trans);
            }
            yield TransactionCompleted(trans);

          }
        } else {
          trans.respMessage = event.respMap[6208];
          yield TransactionRejected(trans);
        }
      }
    }
    //
    else if (event is TransFinishChip) {

      if (await pinpad.finishChip(event.trans.respCode, event.trans.entryMode, event.trans.responseEmvTags) != 0) {
        //TODO: if approved reversal may be needed at this point
        trans.clear();
        yield TransactionError();
      }
    }
    // finish chip
    else if (event is TransFinishChipComplete){
      if (event.finishData['decision'] != null) trans.cardDecision = event.finishData['decision'];
      if (event.finishData['tags'] != null) trans.finishTags = event.finishData['tags'];

      if (trans.cardDecision == 0) {
        if (trans.type == 'Venta')
          transRepository.updateTrans(trans);
        else {
          //update original transaction
          originalTrans.voided = true;
          transRepository.updateTrans(originalTrans);
          //add void to database
          trans.id = (await transRepository.getMaxId()) + 1;
          transRepository.createTrans(trans);
        }
        this.add(TransMerchantReceipt());
        yield TransactionPrintMerchantReceipt(trans);
      } else {
        trans.respMessage = 'Transacción Denegada Por Tarjeta';
        yield TransactionRejected(trans);
      }
    }
    // card was removed at the end of the emv flow - this the normal scenario
    else if (event is TransRemoveCard) {
      if (trans.cardType == Pinpad.CHIP) {
        doBeep = true;
        pinpad.removeCard();
        this.add(RemovingCard());
        yield TransactionShowMessage('Retire Tarjeta');
      }
      else
        yield TransactionFinish(trans);
    }
    // alarm to beep while card is not removed
    else if (event is RemovingCard){
      if (doBeep) {
        pinpad.beep();
        this.add(RemovingCard());
        await new Future.delayed(const Duration(seconds: 2));
      }
    }
    else if (event is TransCardRemoved) {
      doBeep = false;
      this.add(TransfinishTransaction());
      yield TransactionFinish(trans);
    }
    //print receipt
    else if (event is TransMerchantReceipt) {
      Receipt receipt = new Receipt(context);

      yield TransactionPrintMerchantReceipt(trans);
      receipt.printTransactionReceipt(true, trans);
      this.add(TransCustomerReceipt());
    } else if (event is TransCustomerReceipt) {
      Receipt receipt = new Receipt(context);

      yield TransactionPrintCustomerReceipt(trans);
      receipt.printTransactionReceipt(false, trans);
      await new Future.delayed(const Duration(seconds: 3));
      if (trans.cardType == Pinpad.CHIP) {
        //pinpad.removeCard();
        //yield TransactionShowMessage('Retire Tarjeta');
        yield TransactionCompleted(trans);
      } else {
        yield TransactionFinish(trans);
      }
    }
    // pinpad error detected
    else if (event is TransCardError) {
      trans.clear();
      yield TransactionError();
    }
  }

  bool _validateChipData(Trans trans) {
    if ((trans.track2.contains(trans.pan)) && (trans.track2.substring(trans.track2.indexOf('=')).contains(trans.expDate.substring(0, 4))))
      return true;
    else
      return false;
  }

  Future<int> _validateBin(String pan) async {
    BinRepository binRepository = new BinRepository();
    int binId = await binRepository.getBinId(pan.substring(0, 8));
    return binId;
  }
}
