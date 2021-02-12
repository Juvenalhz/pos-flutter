part of 'batch_bloc.dart';

abstract class BatchState extends Equatable {
  const BatchState();
}

class BatchInitial extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchFinish extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchEmpty extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchMissingTipAdjust extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchConfirm extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchShowMessage extends BatchState {
  final String message;

  BatchShowMessage(this.message);

  @override
  List<Object> get props => [message];
}

class BatchConnecting extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchSending extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchReceiving extends BatchState {
  @override
  List<Object> get props => [];
}

class BatchCommError extends BatchState {
  @override
  List<Object> get props => [];
}
