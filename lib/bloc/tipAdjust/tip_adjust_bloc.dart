import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/receipt.dart';
import 'package:pay/utils/reports.dart';

part 'tip_adjust_event.dart';
part 'tip_adjust_state.dart';

class TipAdjustBloc extends Bloc<TipAdjustEvent, TipAdjustState> {
  TipAdjustBloc() : super(TipAdjustInitial());
  var trans = new Trans();

  @override
  Stream<TipAdjustState> mapEventToState(
    TipAdjustEvent event,
  ) async* {
    if (event is TipAdjustInitialEvent) {
      TransRepository transRepository = new TransRepository();
      List<Map<String, dynamic>> transList = await transRepository.getAllTrans(where: 'binType = 1 and reverse = 0');
      List<Trans> listTrans = new List<Trans>();

      transList.forEach((element) {
        listTrans.add(Trans.fromMap(element));
      });

      yield TipAdjustDataReady(listTrans);
    } else if (event is TipAdjustPrintReceiptCopy) {
      TransRepository transRepository = new TransRepository();
      trans = Trans.fromMap(await transRepository.getTrans(event.id));
      Receipt receipt = new Receipt(event.context);

      receipt.printTransactionReceiptCopy(event.type, trans);
    } else if (event is TipAdjustAskTip) {
      trans = event.trans;
      if (trans.tipAdjusted == false) {
        yield TipAdjustPromptTip(event.trans);
      } else {
        this.add(TipAdjustInitialEvent());
      }
    } else if (event is TipAdjustAddTip) {
      if (trans.baseAmount + event.tip <= trans.originalTotal) {
        trans.tip = event.tip;
        trans.total = trans.baseAmount + trans.tip;
      } else {
        yield TipAdjustShowMessage(trans, 'Promina Exede El Monto Maximo Permitido');
      }
    }
  }
}
