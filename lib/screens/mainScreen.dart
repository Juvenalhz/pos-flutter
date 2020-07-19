import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/bloc.dart';
import 'package:pay/bloc/merchant_bloc.dart';
import 'package:pay/screens/splash.dart';
import 'amount.dart';
import 'mainMenu.dart';

class MainScreen extends StatelessWidget{
  MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDev = (const String.fromEnvironment('dev') == 'true');
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
    var scaffoldKey = GlobalKey<ScaffoldState>();

    merchantBloc.add(GetMerchant(1));

    return MaterialApp(
      debugShowCheckedModeBanner: isDev,
      title: 'APOS',
      home: Scaffold(
          key: scaffoldKey,
          drawer: MainMenu(),
          body:
            SafeArea(
              child: BlocBuilder<MerchantBloc, MerchantState>(
                builder: (context, state){
                  if (state is MerchantLoaded) {
                    return Scaffold(
                        body: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
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
                                  child:
                                    Center(child: Text(state.merchant.name, style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30
                                  ),)
                                ),
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
                              ]
                            ),
                            Expanded(
                              child: Stack(
                                children:<Widget>[
                                  Container(
                                    color: Color(0xFF0D47A1),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30)), color: Colors.white),
                                    child: AmountEntry('Monto:'),
                                  ),

                              ]
                              )
                            ),
                          ],
                        ),
                      );
                    }
                    else {
                      return SplashScreen();
                    }
                }
              ),
            )
      ),
    );
  }
}
