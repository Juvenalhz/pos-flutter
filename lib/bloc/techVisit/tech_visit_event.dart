part of 'tech_visit_bloc.dart';

abstract class TechVisitEvent extends Equatable {
  const TechVisitEvent();
}

class TechVisitInitialEvent extends TechVisitEvent {
  @override
  List<Object> get props => [];
}

class TechVisitInitPinpad extends TechVisitEvent {
  final Pinpad pinpad;

  TechVisitInitPinpad(this.pinpad);

  @override
  List<Object> get props => [pinpad];
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

class TechVisitCardRead extends TechVisitEvent {
  final Map<String, dynamic> params;

  TechVisitCardRead(this.params);

  @override
  List<Object> get props => [params];
}

class TechVisitPinEntered extends TechVisitEvent {
  final Map<String, dynamic> pinData;

  TechVisitPinEntered([this.pinData]);

  @override
  List<Object> get props => [this.pinData];
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
