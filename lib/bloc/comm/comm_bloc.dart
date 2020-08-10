import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/repository/comm_repository.dart';
import 'comm_event.dart';
import 'comm_state.dart';

class CommBloc extends Bloc<CommEvent, CommState> {
  final CommRepository commRepository;

  CommBloc({@required this.commRepository}) : super(null);

  @override
  CommState get initialState => CommInitial();

  @override
  Stream<CommState> mapEventToState(CommEvent event) async* {
    yield CommLoading();

    if (event is GetComm) {
      int numComms = await commRepository.getCountComms();

      if (numComms == 0) {
        yield CommMissing();
      } else {
        Map<String, dynamic> commMap = await commRepository.getComm(event.id);
        Comm comm = new Comm.fromMap(commMap);

        if (comm == null) yield CommLoading();

        yield CommLoaded(comm: comm);
      }
    } else if (event is UpdateComm) {
      yield CommLoading();
      await commRepository.updateComm(event.comm);
      yield CommGet(id: event.comm.id);
    }
  }
}
