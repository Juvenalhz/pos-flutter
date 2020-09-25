import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/utils/pinpad.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial());
  var trans = new Trans();
  TransactionEvent lastEvent;
  Pinpad pp = new Pinpad();

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is TransactionInitial) {
      yield TransactionAddAmount(trans);
    }
    else if (event is TransAddAmount) {
      trans.baseAmount = event.amount;
      trans.total = event.amount;
      yield TransactionAddTip(trans);
    }
    else if (event is TransAddTip) {
      trans.tip = event.tip;
      trans.total += event.tip;
      yield TransactionLoadEmvTable();
      this.add(TransLoadEmvTables());
    }
    else if (event is TransAskConfirmation) {
      yield TransactionAskConfirmation();
    }
    else if (event is TransLoadEmvTables) {
      EmvRepository emvRepository = new EmvRepository();
      AidRepository aidRepository = new AidRepository();
      PubKeyRepository pubKeyRepository = new PubKeyRepository();
      Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
      List<Map<String, dynamic>> aids = await aidRepository.getAids();
      List<Map<String, dynamic>> pubKeys = await pubKeyRepository.getPubKeys();
      pp.loadTables(emv.toMap(), aids, pubKeys);
      this.add(TransWaitEmvTablesLoaded());
      yield TransactionWaitEmvTablesLoaded();
    }
    else if (event is TransGetCard){
      pp.getCard(event.trans.toMap());
    }

    lastEvent = event;
  }
}
