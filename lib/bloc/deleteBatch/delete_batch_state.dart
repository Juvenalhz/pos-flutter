part of 'delete_batch_bloc.dart';

abstract class DeleteBatchState extends Equatable {
  const DeleteBatchState();
}

class DeleteBatchInitial extends DeleteBatchState {
  @override
  List<Object> get props => [];
}

class DeleteBatchDone extends DeleteBatchState {
  @override
  List<Object> get props => [];
}

class DeleteBatchNotExist extends DeleteBatchState {
  @override
  List<Object> get props => [];
}

class DeleteBatchAskDelete extends DeleteBatchState {
  @override
  List<Object> get props => [];
}

class DeleteBatchExit extends DeleteBatchState {
  @override
  List<Object> get props => [];
}
