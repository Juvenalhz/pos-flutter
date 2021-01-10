part of 'tech_visit_bloc.dart';

abstract class TechVisitEvent extends Equatable {
  const TechVisitEvent();
}

class TechVisitInitialEvent extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitAddVisitType extends TechVisitEvent {
  final int visitType;

  TechVisitAddVisitType(this.visitType);

  @override
  List<Object> get props => [visitType];
}

class TechVisitAddRequirementType extends TechVisitEvent {
  final int requirementType;

  TechVisitAddRequirementType(this.requirementType);

  @override
  List<Object> get props => [requirementType];
}

class TechVisitAddRequirementBack extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitPasswordOk extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitConnect extends TechVisitEvent {
  final Comm comm;

  TechVisitConnect(this.comm);

  @override
  List<Object> get props => [this.comm];
}

class TechVisitSend extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitReceive extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitProcess extends TechVisitEvent {
  @override
  List<Object> get props => [];
}
