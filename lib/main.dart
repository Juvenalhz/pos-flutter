import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/screens/mainScreen.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/bloc/merchantBloc.dart';

import 'bloc/acquirer/acquirer_bloc.dart';
import 'bloc/comm/comm_bloc.dart';
import 'bloc/initialization/initialization_bloc.dart';
import 'bloc/terminal/terminal_bloc.dart';
import 'repository/acquirer_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {
  bool isDev = (const String.fromEnvironment('dev') != null);
  MerchantRepository merchantRepository = new MerchantRepository();
  TerminalRepository terminalRepository = new TerminalRepository();
  CommRepository commRepository = new CommRepository();
  EmvRepository emvRepository = new EmvRepository();
  AcquirerRepository acquirerRepository = new AcquirerRepository();
  final appdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: MultiBlocProvider(providers: [
        BlocProvider<MerchantBloc>(
          create: (context) => MerchantBloc(merchantRepository: merchantRepository),
        ),
        BlocProvider<TerminalBloc>(
          create: (context) => TerminalBloc(terminalRepository: terminalRepository),
        ),
        BlocProvider<CommBloc>(
          create: (context) => CommBloc(commRepository: commRepository),
        ),
        BlocProvider<EmvBloc>(
          create: (context) => EmvBloc(emvRepository: emvRepository),
        ),
        BlocProvider<AcquirerBloc>(
          create: (context) => AcquirerBloc(acquirerRepository: acquirerRepository),
        ),
        BlocProvider<InitializationBloc>(create: (context) => InitializationBloc()),
      ], child: MainScreen()),
    ));
  }
}
