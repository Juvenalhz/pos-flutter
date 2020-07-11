import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pay/models/merchant.dart';
import 'bloc.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  Merchant merchant;

  MerchantBloc(MerchantState initialState) : super(initialState);

  @override
  MerchantState get initialState => InitialMerchantState();

  @override
  Stream<MerchantState> mapEventToState(MerchantEvent event) async* {}
}
