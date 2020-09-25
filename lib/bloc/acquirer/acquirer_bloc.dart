import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'acquirer_event.dart';
import 'acquirer_state.dart';

class AcquirerBloc extends Bloc<AcquirerEvent, AcquirerState> {
  final AcquirerRepository acquirerRepository;

  AcquirerBloc({@required this.acquirerRepository}) : super(null);

  @override
  AcquirerState get initialState => AcquirerInitial();

  @override
  Stream<AcquirerState> mapEventToState(AcquirerEvent event) async* {
    yield AcquirerLoading();

    if (event is GetAcquirer) {
      int numAcquirers = await acquirerRepository.getCountacquirers();

      if (numAcquirers == 0) {
        yield AcquirerMissing();
      } else {
        Map<String, dynamic> acquirerMap = await acquirerRepository.getacquirer(event.id);
        Acquirer acquirer = new Acquirer.fromMap(acquirerMap);

        if (acquirer == null) yield AcquirerLoading();

        yield AcquirerLoaded(acquirer: acquirer);
      }
    } else if (event is UpdateAcquirer) {
      yield AcquirerLoading();
      await acquirerRepository.updateacquirer(event.acquirer);
      yield AcquirerGet(id: event.acquirer.id);
    }
  }
}
