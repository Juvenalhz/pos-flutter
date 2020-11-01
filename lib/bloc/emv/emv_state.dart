import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/emv.dart';

@immutable
abstract class EmvState extends Equatable {
  const EmvState();
}

class EmvInitial extends EmvState {
  @override
  List<Object> get props => [];
}

class EmvLoading extends EmvState {
  @override
  List<Object> get props => [];
}

class EmvMissing extends EmvState {
  @override
  List<Object> get props => [];
}

class EmvGet extends EmvState {
  final int id;

  const EmvGet({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class EmvDelete extends EmvState {
  final int id;

  const EmvDelete({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class EmvLoaded extends EmvState {
  final Emv emv;

  const EmvLoaded({@required this.emv}) : assert(emv != null);

  @override
  List<Object> get props => [emv];
}
