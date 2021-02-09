part of 'tech_visit_bloc.dart';

abstract class TechVisitState extends Equatable {
  const TechVisitState();
}

class TechVisitInitial extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitGetCard extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitShowPinMessage extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitAskVisitType extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitAskRequirementType extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitConnecting extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitSending extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitReceiving extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitCompleted extends TechVisitState {
  final String message;

  TechVisitCompleted(this.message);

  @override
  List<Object> get props => [message];
}

class TechVisitFailed extends TechVisitState {
  final String message;

  TechVisitFailed(this.message);

  @override
  List<Object> get props => [message];
}

class TechVisitCommError extends TechVisitState {
  @override
  List<Object> get props => [];
}

class TechVisitShowMessage extends TechVisitState {
  final String message;

  TechVisitShowMessage(this.message);

  @override
  List<Object> get props => [message];
}
