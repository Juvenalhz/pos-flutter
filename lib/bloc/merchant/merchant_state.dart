import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/merchant.dart';


@immutable
abstract class MerchantState extends Equatable {
  const MerchantState();
}

class MerchantInitial extends MerchantState {
  @override
  List<Object> get props => [];
}

class MerchantLoading extends MerchantState {
  @override
  List<Object> get props => [];
}

class MerchantMissing extends MerchantState {
  @override
  List<Object> get props => [];
}

class MerchantGet extends MerchantState {
  final int id;

  const MerchantGet({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class MerchantDelete extends MerchantState {
  final int id;

  const MerchantDelete({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class MerchantLoaded extends MerchantState {
  final Merchant merchant;

  const MerchantLoaded({@required this.merchant}) : assert(merchant != null);

  @override
  List<Object> get props => [merchant];
}
