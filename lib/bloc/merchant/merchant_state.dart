import 'package:equatable/equatable.dart';

abstract class MerchantState extends Equatable {
  const MerchantState();

  @override
  List<Object> get props => [];
}

class InitialMerchantState extends MerchantState {}
