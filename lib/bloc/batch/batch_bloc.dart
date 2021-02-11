import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/trans_repository.dart';

part 'batch_event.dart';
part 'batch_state.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  MerchantRepository merchantRepository = new MerchantRepository();
  AcquirerRepository acquirerRepository = new AcquirerRepository();
  TransRepository transRepository = new TransRepository();
  Merchant merchant;
  Acquirer acquirer;

  BatchBloc() : super(BatchInitial());

  @override
  Stream<BatchState> mapEventToState(
    BatchEvent event,
  ) async* {
    if (event is BatchInitialEvent) {
    } else if (event is BatchCheckAdjustedTips) {
      List<Map<String, dynamic>> acquirers = await acquirerRepository.getAllacquirers(where: 'industryType = 1');
      if (acquirers.length > 0) {
        List<Map<String, dynamic>> transNotAdjusted = await transRepository.getAllTrans(where: 'binType = 1 and tipAdjusted = 0 and reverse = 0');

        if (transNotAdjusted.length > 0) {
          yield BatchMissingTipAdjust();
        }
      }
    }
  }
}
