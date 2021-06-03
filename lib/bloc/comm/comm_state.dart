import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/comm.dart';

@immutable
abstract class CommState extends Equatable {
  const CommState();
}

class CommInitial extends CommState {
  @override
  List<Object> get props => [];
}

class CommLoading extends CommState {
  @override
  List<Object> get props => [];
}

class CommMissing extends CommState {
  @override
  List<Object> get props => [];
}

class CommGet extends CommState {
  final int id;

  const CommGet({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class CommDelete extends CommState {
  final int id;

  const CommDelete({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class CommLoaded extends CommState {
  final Comm comm;

  const CommLoaded({@required this.comm}) : assert(comm != null);

  @override
  List<Object> get props => [comm];
}
