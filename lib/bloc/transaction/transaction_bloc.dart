import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/aid.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/screens/transaction.dart';
import 'package:pay/utils/pinpad.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  Pinpad pinpad;
  var trans = new Trans();
  BuildContext context;

  TransactionBloc(this.context) : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    print(event.toString());
    if (event is TransactionInitial) {
      yield TransactionAddAmount(trans);
    }
    // read base amount
    else if (event is TransStartTransaction) {
      await new Future.delayed(const Duration(seconds: 3));
      yield TransactionAddAmount(trans);
    }
    // base amount added, transaction initial data
    else if (event is TransAddAmount) {
      trans.baseAmount = event.amount;
      trans.total = event.amount;
      trans.type = 'Compra';
      //TODO: check configuration if tip is on or off
      yield TransactionAddTip(trans);
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
      this.add(TransAskConfirmation(trans));
    }
    // going back to the tip amount screen
    else if (event is TransAskTip) {
      trans.tip = event.tip;
      yield TransactionAddTip(trans);
    }
    // show confirmation screen
    else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation(trans);
    }
    // user selected ok on Confirmation screen
    else if (event is TransConfirmOK) {
      this.add(TransLoadEmvTables(event.pinpad));
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
      if (event.card['pan'] != null) trans.pan = event.card['pan'];
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
        if (event.trans.cardType == pinpad.MAG_STRIPE)
          this.add(TransOnlineTransaction(event.trans));
        else {
          if (_validateChipData(trans) == true) {
            this.add(TransGoOnChip(trans));
          } else {
            yield TransactionShowMessage(("Error en Tarjeta"));
            trans.clear();
            await new Future.delayed(const Duration(seconds: 3));
            yield TransactionError();
          }
        }
      }
    }
    // continue chip card emv flow, will perform risk analisys, pin entry, online/offline decision
    else if (event is TransGoOnChip) {
      AidRepository aidRepository = new AidRepository();
      TerminalRepository terminalRepository = new TerminalRepository();
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
    }
    // analyze chip desition online/offline/decline by chip
    else if (event is TransGoOnChipDecision) {
      this.add(TransOnlineTransaction(trans));
    }
    // start online process
    else if (event is TransOnlineTransaction) {
      this.add(TransProcessResponse(trans));
    }
    //
    else if (event is TransProcessResponse) {
      if (event.trans.cardType == pinpad.CHIP) this.add(TransFinishChip(trans));
    }
    //
    else if (event is TransFinishChip) {
      if (await pinpad.finishChip("00", event.trans.entryMode, event.trans.responseEmvTags) != 0) {
        //TODO: if approved reversal may be needed at this point
        trans.clear();
        yield TransactionError();
      }
    }
    // card was removed at the end of the emv flow - this the normal scenario
    else if (event is TransCardRemoved) {
      if (event.finishData['decision'] != null) trans.cardDecision = event.finishData['decision'];
      if (event.finishData['tags'] != null) trans.finishTags = event.finishData['tags'];

      yield TransactionCompleted(trans);
      //this.add(TransStartTransaction());
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
