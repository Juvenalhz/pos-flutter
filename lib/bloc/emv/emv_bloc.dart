import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/repository/emv_repository.dart';
import 'emv_event.dart';
import 'emv_state.dart';

class EmvBloc extends Bloc<EmvEvent, EmvState> {
  final EmvRepository emvRepository;

  EmvBloc({@required this.emvRepository}) : super(null);

  @override
  EmvState get initialState => EmvInitial();

  @override
  Stream<EmvState> mapEventToState(EmvEvent event) async* {
    yield EmvLoading();

    if (event is GetEmv) {
      int numEmvs = await emvRepository.getCountEmvs();

      if (numEmvs == 0) {
        yield EmvMissing();
      } else {
        Map<String, dynamic> emvMap = await emvRepository.getEmv(event.id);
        Emv emv = new Emv.fromMap(emvMap);

        if (emv == null) yield EmvLoading();

        yield EmvLoaded(emv: emv);
      }
    } else if (event is UpdateEmv) {
      yield EmvLoading();
      await emvRepository.updateEmv(event.emv);
      yield EmvGet(id: event.emv.id);
    }
  }
}
