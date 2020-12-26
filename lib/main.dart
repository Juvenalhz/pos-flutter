import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/bloc/echotestBloc.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/bloc/acquirer/acquirer_bloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/deleteReversalBloc.dart';
import 'package:pay/bloc/initializationBloc.dart';
import 'package:pay/bloc/lastSaleBloc.dart';
import 'package:pay/bloc/terminalBloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/bloc/totalsReportBloc.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/screens/mainScreen.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/bloc/merchantBloc.dart';

import 'repository/acquirer_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(InitializationApp());
}

class InitializationApp extends StatelessWidget {
  final MerchantRepository merchantRepository = new MerchantRepository();
  final TerminalRepository terminalRepository = new TerminalRepository();
  final CommRepository commRepository = new CommRepository();
  final EmvRepository emvRepository = new EmvRepository();
  final AcquirerRepository acquirerRepository = new AcquirerRepository();
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
        BlocProvider<TransactionBloc>(create: (context) => TransactionBloc(context)),
        BlocProvider<DeleteReversalBloc>(create: (context) => DeleteReversalBloc()),
        BlocProvider<EchoTestBloc>(create: (context) => EchoTestBloc()),
        BlocProvider<LastSaleBloc>(create: (context) => LastSaleBloc()),
        BlocProvider<DetailReportBloc>(create: (context) => DetailReportBloc()),
        BlocProvider<TotalsReportBloc>(create: (context) => TotalsReportBloc()),
      ], child: MainScreen()),
    ));
  }
}
