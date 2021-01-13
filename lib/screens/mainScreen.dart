import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/acquirerBloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_event.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/bloc/emv/emv_event.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/bloc/terminal/terminal_bloc.dart';
import 'package:pay/bloc/terminal/terminal_event.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/screens/DeleteBatch.dart';
import 'package:pay/screens/DeleteReversal.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/screens/Transaction.dart';
import 'ConfigurationScreen.dart';
import 'DetailReport.dart';
import 'EchoTest.dart';
import 'Initialization.dart';
import 'LastSale.dart';
import 'SelectAcquirer.dart';
import 'amount.dart';
import 'mainMenu.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    final TerminalBloc terminalBloc = BlocProvider.of<TerminalBloc>(context);
    final CommBloc commBloc = BlocProvider.of<CommBloc>(context);
    final EmvBloc emvBloc = BlocProvider.of<EmvBloc>(context);
    final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);
    var scaffoldKey = GlobalKey<ScaffoldState>();

    merchantBloc.add(GetMerchant(1));
    terminalBloc.add(GetTerminal(1));
    commBloc.add(GetComm(1));
    emvBloc.add(GetEmv(1));
    acquirerBloc.add(GetAcquirer(1));

    return MaterialApp(
      debugShowCheckedModeBanner: isDev,
      title: 'APOS',
      routes: {
        '/configuration': (context) => ConfigurationScreen(),
        '/initialization': (context) => Initialization(),
        '/transaction': (contex) => Transaction(),
        '/deleteReversal': (context) => DeleteReversal(),
        '/SelectAcquirer': (context) => SelectAcquirer(),
        '/EchoTest': (context) => EchoTest(),
        '/LastSale': (context) => LastSale(),
        '/DetailReport': (context) => DetailReport(),
        '/DeleteBatch': (context) => DeleteBatch(),
      },
      home: Scaffold(
          key: scaffoldKey,
          drawer: MainMenu(),
          body: SafeArea(
            child: BlocBuilder<MerchantBloc, MerchantState>(builder: (context, state) {
              if (state == null) {
                merchantBloc.add(GetMerchant(1));
                terminalBloc.add(GetTerminal(1));
                commBloc.add(GetComm(1));
                return SplashScreen();
              }
              if (state is MerchantLoaded) {
                return Scaffold(
                 //body: Text('aqui'),
                  body: Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            gradient: LinearGradient(
                              begin: Alignment(0.0, 0.6),
                              end: Alignment(0.0, 0.0),
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Colors.blue,
                              ],
                            ),
                          ),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 10, 0),
                            child: Text(
                              state.merchant.nameL1,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          )),
                        ),
                        Positioned(
                          left: 6,
                          top: 6,
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.menu),
                            onPressed: () => scaffoldKey.currentState.openDrawer(),
                          ),
                        ),
                      ]),
                      Expanded(
                          child: Stack(children: <Widget>[
                        Container(
                          color: Color(0xFF0D47A1),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                          child: AmountEntry('Monto:', onClickEnter),
                        ),
                      ])),
                    ],
                  ),
                );
              } else if (state is MerchantMissing) {
                return AlertDialog(
                  title: Text(
                    'Inicializacion',
                    style: TextStyle(color: Color(0xFF0D47A1)),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('El terminal no esta inicializado.'),
                        Text('Ejecutar inicialization desde el menu de la aplicacion...'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Color(0xFF0D47A1)),
                      ),
                      onPressed: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ],
                );
              } else {
                return SplashScreen();
              }
            }),
          )),
    );
  }

  void onClickEnter(BuildContext context, int amount) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (amount > 0) {
      transactionBloc.add(TransAddAmount(amount));
      Navigator.pushNamed(context, '/transaction');
    }
  }
}
