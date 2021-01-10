part of 'delete_batch_bloc.dart';

abstract class DeleteBatchEvent extends Equatable {
  const DeleteBatchEvent();
}

class DeleteBatchPending extends DeleteBatchEvent {
  @override
  List<Object> get props => [];
}

class DeleteBatchOK extends DeleteBatchEvent {
  @override
  List<Object> get props => [];
}

class DeleteBatchCancel extends DeleteBatchEvent {
  @override
  List<Object> get props => [];
}
