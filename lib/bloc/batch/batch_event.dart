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

class BatchConfirmOk extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchSendReversal extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchReceiveReversal extends BatchEvent {
  Trans transReversal;

  BatchReceiveReversal(this.transReversal);

  @override
  List<Object> get props => [transReversal];
}

class BatchConnect extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchSendRequest extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchReceive extends BatchEvent {
  @override
  List<Object> get props => [];
}

class BatchProcessResponse extends BatchEvent {
  final Map<int, String> respMap;

  BatchProcessResponse(this.respMap);

  @override
  List<Object> get props => [respMap];
}

class BatchComplete extends BatchEvent {
  @override
  List<Object> get props => [];
}
