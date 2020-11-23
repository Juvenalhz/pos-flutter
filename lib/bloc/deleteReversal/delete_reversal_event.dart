part of 'delete_reversal_bloc.dart';

abstract class DeleteReversalEvent extends Equatable {
  const DeleteReversalEvent();
}

class DeleteReversalPending extends DeleteReversalEvent {
  @override
  List<Object> get props => [];
}

class DeleteReversalOK extends DeleteReversalEvent {
  @override
  List<Object> get props => [];
}

class DeleteReversalCancel extends DeleteReversalEvent {
  @override
  List<Object> get props => [];
}