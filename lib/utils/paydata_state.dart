import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/merchant.dart';

abstract class PaydataState extends Equatable {
  const PaydataState();
}

class InitialPaydataState extends PaydataState {
  @override
  List<Object> get props => [];
}


@immutable
abstract class MerchantListState {
  final List<Merchant> merchants;

  MerchantListState({this.merchants});
}

class InitialMerchantListState extends MerchantListState {}

class Loading extends MerchantListState {}

class Loaded extends MerchantListState {
  Loaded({@required List<Merchant> merchants}) : super(merchants: merchants);
}