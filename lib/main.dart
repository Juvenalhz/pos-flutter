import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/screens/mainScreen.dart';
import 'package:pay/utils/communication.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/bloc/merchantBloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {
  bool isDev = (const String.fromEnvironment('dev') != null);
  MerchantRepository merchantRepository = new MerchantRepository();
  final appdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<MerchantBloc>(create: (context) => MerchantBloc(merchantRepository: merchantRepository), child: MainScreen()),
      ),
    );
  }
}
