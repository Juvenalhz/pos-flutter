
part of 'acquirer_bloc.dart';

@immutable
abstract class AcquirerState extends Equatable {
  const AcquirerState();
}

class AcquirerInitial extends AcquirerState {
  @override
  List<Object> get props => [];
}

class AcquirerLoading extends AcquirerState {
  @override
  List<Object> get props => [];
}

class AcquirerMissing extends AcquirerState {
  @override
  List<Object> get props => [];
}

class AcquirerGet extends AcquirerState {
  final int id;

  const AcquirerGet({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class AcquirerDelete extends AcquirerState {
  final int id;

  const AcquirerDelete({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class AcquirerLoaded extends AcquirerState {
  final Acquirer acquirer;

  const AcquirerLoaded({@required this.acquirer}) : assert(acquirer != null);

  @override
  List<Object> get props => [acquirer];
}

class AcquirerGetAll extends AcquirerState {
  final List<Map<String, dynamic>> acquirerList;

  const AcquirerGetAll(this.acquirerList) ;

  @override
  List<Object> get props => [acquirerList];
}

class AcquirerSelectionExit extends AcquirerState {

  @override
  List<Object> get props => [];
}
