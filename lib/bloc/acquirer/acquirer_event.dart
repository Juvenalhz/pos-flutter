part of 'acquirer_bloc.dart';

abstract class AcquirerEvent extends Equatable {
  const AcquirerEvent();

  @override
  List<Object> get props => [];
}

class AcquirerLoadInProgress extends AcquirerEvent {}

class AcquirerLoadSuccess extends AcquirerEvent {
  final Acquirer acquirer;

  const AcquirerLoadSuccess([this.acquirer]);

  @override
  List<Object> get props => [acquirer];

  @override
  String toString() => 'AcquirerLoadSuccess { acquirer: $acquirer }';
}

class GetAcquirer extends AcquirerEvent {
  final int id;

  const GetAcquirer([this.id]);
}

class AcquirerLoadFailure extends AcquirerEvent {}

class AcquirerTerminal extends AcquirerEvent {
  final int id;

  const AcquirerTerminal([this.id]);
}

class UpdateAcquirer extends AcquirerEvent {
  final Acquirer acquirer;

  const UpdateAcquirer(this.acquirer);
}

class GetAllAcquirer extends AcquirerEvent {
  @override
  List<Object> get props => [];
}

class AcquirerSelectionFinish extends AcquirerEvent {
  @override
  List<Object> get props => [];
}
