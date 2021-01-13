import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/trans_repository.dart';

part 'delete_reversal_event.dart';
part 'delete_reversal_state.dart';

class DeleteReversalBloc extends Bloc<DeleteReversalEvent, DeleteReversalState> {
  DeleteReversalBloc() : super(DeleteReversalInitial());

  @override
  Stream<DeleteReversalState> mapEventToState(
    DeleteReversalEvent event,
  ) async* {
    if (event is DeleteReversalPending) {
      TransRepository transRepository = new TransRepository();

      if (await transRepository.getCountReversal() != 0) {
        yield DeleteReversalAskDelete();
      }
      else {
        yield DeleteReversalNotExist();
      }
    }
    else if (event is DeleteReversalOK) {
      TransRepository transRepository = new TransRepository();

      Trans transReversal = Trans.fromMap(await transRepository.getTransReversal());
      await transRepository.deleteTrans(transReversal.id);
      yield DeleteReversalDone();
    }
    else if (event is DeleteReversalCancel){
      yield DeleteReversalExit();
    }
  }
}
