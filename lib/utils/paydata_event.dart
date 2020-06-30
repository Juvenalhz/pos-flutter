import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/merchant.dart';

abstract class PaydataEvent extends Equatable {
  const PaydataEvent();
}

class GetMerchantData extends PaydataEvent{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

@immutable
abstract class MerchantListEvent {
  final merchant;

  MerchantListEvent({this.merchant});
}

class GetMerchants extends MerchantListEvent {
  GetMerchants({Merchant merchant}) : super(merchant: merchant);
}

class DeleteMerchant extends MerchantListEvent {
  DeleteMerchant({@required Merchant merchant}) : super(merchant: merchant);
}