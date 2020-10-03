import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/aid.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
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
    if (event is TransactionInitial) {
      yield TransactionAddAmount(trans);
    } else if (event is TransAddAmount) {
      trans.baseAmount = event.amount;
      trans.total = event.amount;
      yield TransactionAddTip(trans);
    } else if (event is TransAddTip) {
      trans.tip = event.tip;
      trans.total += event.tip;
      yield TransactionLoadEmvTable();
      //this.add(TransLoadEmvTables());
    } else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation();
    } else if (event is TransLoadEmvTables) {
      EmvRepository emvRepository = new EmvRepository();
      AidRepository aidRepository = new AidRepository();
      PubKeyRepository pubKeyRepository = new PubKeyRepository();
      Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
      List<Map<String, dynamic>> aids = await aidRepository.getAids();
      List<Map<String, dynamic>> pubKeys = await pubKeyRepository.getPubKeys();
      pinpad = event.pinpad;
      pinpad.loadTables(emv.toMap(), aids, pubKeys);
      this.add(TransWaitEmvTablesLoaded());
      yield TransactionWaitEmvTablesLoaded();
    } else if (event is TransShowMessage) {
      yield TransactionShowMessage(event.message);
    } else if (event is TransGetCard) {
      pinpad.getCard(trans.toMap());
    } else if (event is TransCardWasRead) {
      print(event.card.toString());

      if (event.card['serviceCode'] != null) trans.serviceCode = event.card['serviceCode'];
      if (event.card['appType'] != null) trans.appType = event.card['appType'];
      if (event.card['cardType'] != null) trans.cardType = event.card['cardType'];
      if (event.card['PANSequenceNumber'] != null) trans.panSequenceNumber = event.card['PANSequenceNumber'];
      if (event.card['cardholderName'] != null) trans.cardholderName = event.card['cardholderName'];
      if (event.card['pan'] != null) trans.pan = event.card['pan'];
      if (event.card['track1'] != null) trans.track1 = event.card['track1'];
      if (event.card['track2'] != null) trans.track2 = event.card['track2'];
      if (event.card['expDate'] != null) trans.expDate = event.card['expDate'];
      if (event.card['appLabel'] != null) trans.appLabel = event.card['appLabel'];
      if (event.card['recordID'] != null) trans.aidID = event.card['recordID'];

      yield TransactionCardRead(trans);
      this.add(TransGoOnChip(trans));
    } else if (event is TransGoOnChip) {
      AidRepository aidRepository = new AidRepository();
      TerminalRepository terminalRepository = new TerminalRepository();
      AID aid = AID.fromMap(await aidRepository.getAid(trans.aidID));
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));

      pinpad.goOnChip(trans.toMap(), terminal.toMap(), aid.toMap());
      this.add(TransFinshChip());
      yield TransactionFinshChip();
    } else if (event is TransProcessCard) {
    } else if (event is TransOnlineTransaction) {
    } else if (event is TransProcessResponse) {
    } else if (event is TransFinshChip) {
      pinpad.finishChip("00", trans.entryMode, trans.responseEmvTags);
    }
  }
}
