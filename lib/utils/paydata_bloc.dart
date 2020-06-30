import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import './bloc.dart';

class PaydataBloc extends Bloc<PaydataEvent, PaydataState> {
  @override
  PaydataState get initialState => InitialPaydataState();

  @override
  Stream<PaydataState> mapEventToState(
    PaydataEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

class MerchantListBloc extends Bloc<MerchantListEvent, MerchantListState> {
  final _merchantRepository = MerchantRepository();

  @override
  MerchantListState get initialState => InitialMerchantListState();

  @override
  Stream<MerchantListState> mapEventToState(MerchantListEvent event) async* {
    yield Loading();
    if (event is GetMerchants) {
        List<Merchant> merchants = await _merchantRepository.getMerchants();
        yield Loaded(merchants: merchants);
    } else if (event is DeleteMerchant) {
        await _merchantRepository.deleteMerchant(event.merchant.id);
        yield Loaded(merchants: await _merchantRepository.getMerchants());
    }
  }
}