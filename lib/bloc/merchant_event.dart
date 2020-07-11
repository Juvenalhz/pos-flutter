import 'package:equatable/equatable.dart';
import 'package:pay/models/merchant.dart';

abstract class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object> get props => [];
}

class MerchantLoadInProgress extends MerchantEvent {}

class MerchantLoadSuccess extends MerchantEvent {
  final Merchant merchant;

  const MerchantLoadSuccess([this.merchant]);

  @override
  List<Object> get props => [merchant];

  @override
  String toString() => 'MerchantLoadSuccess { merchant: $merchant }';
}

class GetMerchant extends MerchantEvent{
  final int id;

  const GetMerchant([this.id]);
}
class MerchantLoadFailure extends MerchantEvent {}

class DeleteMerchant extends MerchantEvent {
  final int id;

  const DeleteMerchant([this.id]);
}