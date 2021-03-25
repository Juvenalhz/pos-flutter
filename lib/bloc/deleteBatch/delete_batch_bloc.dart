import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/trans_repository.dart';

part 'delete_batch_event.dart';
part 'delete_batch_state.dart';

class DeleteBatchBloc extends Bloc<DeleteBatchEvent, DeleteBatchState> {
  DeleteBatchBloc() : super(DeleteBatchInitial());

  @override
  Stream<DeleteBatchState> mapEventToState(
    DeleteBatchEvent event,
  ) async* {
    if (event is DeleteBatchPending) {
      TransRepository transRepository = new TransRepository();

      if (await transRepository.getCountTrans(where: 'reverse = 0') != 0) {
        yield DeleteBatchAskDelete();
      } else {
        yield DeleteBatchNotExist();
      }
    } else if (event is DeleteBatchOK) {
      TransRepository transRepository = new TransRepository();

      await transRepository.deleteAllTrans();
      yield DeleteBatchDone();
    } else if (event is DeleteBatchCancel) {
      yield DeleteBatchExit();
    }
  }
}
