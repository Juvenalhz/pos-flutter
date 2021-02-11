part of 'batch_bloc.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();
}

class BatchInitialEvent extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchCheckAdjustedTips extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchMissingTipsOk extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchCancel extends BatchEvent {
  @override
  List<Object> get props => [];
}
