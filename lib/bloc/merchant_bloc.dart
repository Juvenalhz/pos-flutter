import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'merchant_event.dart';
import 'merchant_state.dart';



class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  final MerchantRepository merchantRepository  ;

  MerchantBloc({@required this.merchantRepository}) : super(null) ;

  @override
  MerchantState get initialState => MerchantInitial();

  @override
  Stream<MerchantState> mapEventToState(MerchantEvent event) async* {

    yield MerchantLoading();

    if (event is GetMerchant){
      int numMerchants = await merchantRepository.getCountMerchants();
      Map<String, dynamic> merchantMap = await merchantRepository.getMerchant(event.id);
      Merchant merchant = new Merchant.fromMap(merchantMap);

      if (numMerchants == 0){
        yield MerchantMissing();
      }
      else {
        if (merchant == null)
          yield MerchantLoading();

        yield MerchantLoaded(merchant: merchant);
      }
    }



  }
}