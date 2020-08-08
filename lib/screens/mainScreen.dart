import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/communication.dart';
import 'ConfigurationScreen.dart';
import 'amount.dart';
import 'mainMenu.dart';

void testConnection() async {
  Communication myComm = new Communication('192.168.11.104', 9000, false);

  Uint8List testmessage = new Uint8List.fromList([0,3,3,4,5]);
  myComm.connect().then((value) {
    print(value);
    myComm.sendMessage(testmessage);
  });


}

class MainScreen extends StatelessWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    var scaffoldKey = GlobalKey<ScaffoldState>();

    testConnection();
    merchantBloc.add(GetMerchant(1));

    return MaterialApp(
      debugShowCheckedModeBanner: isDev,
      title: 'APOS',
      routes: {
        '/configuration': (context) => ConfigurationScreen(),
      },
      home: Scaffold(
          key: scaffoldKey,
          drawer: MainMenu(),
          body: SafeArea(
            child: BlocBuilder<MerchantBloc, MerchantState>(builder: (context, state) {
              if (state is MerchantLoaded) {
                return Scaffold(
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
                              child: Text(
                            state.merchant.nameL1,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
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
                              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                              color: Colors.white),
                          child: AmountEntry('Monto:'),
                        ),
                      ])),
                    ],
                  ),
                );
              } else if (state is MerchantMissing)
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
              else {
                return SplashScreen();
              }
            }),
          )),
    );
  }
}
