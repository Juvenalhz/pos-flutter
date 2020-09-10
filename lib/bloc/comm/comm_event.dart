import 'package:equatable/equatable.dart';
import 'package:pay/models/comm.dart';

abstract class CommEvent extends Equatable {
  const CommEvent();

  @override
  List<Object> get props => [];
}

class CommLoadInProgress extends CommEvent {}

class CommLoadSuccess extends CommEvent {
  final Comm comm;

  const CommLoadSuccess([this.comm]);

  @override
  List<Object> get props => [comm];

  @override
  String toString() => 'CommLoadSuccess { comm: $comm }';
}

class GetComm extends CommEvent {
  final int id;

  const GetComm([this.id]);
}

class CommLoadFailure extends CommEvent {}

class DeleteComm extends CommEvent {
  final int id;

  const DeleteComm([this.id]);
}

class UpdateComm extends CommEvent {
  final Comm comm;

  const UpdateComm(this.comm);
}
