part of 'batch_bloc.dart';

abstract class BatchState extends Equatable {
  const BatchState();
}

class BatchInitial extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchMissingTipAdjust extends BatchState {
  @override
  List<Object> get props => [];
}
