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

    merchantBloc.add(GetMerchant(1));

    return MaterialApp(
      debugShowCheckedModeBanner: isDev,
      title: 'APOS',
      home: Scaffold(
          drawer: MainMenu(),
          body:
            BlocBuilder<MerchantBloc, MerchantState>(
              builder: (context, state){
                if (state is MerchantLoaded){
                  return  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        stretch: true,
                        onStretchTrigger: () {
                          return;
                        },
                        expandedHeight: 70,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: <StretchMode>[
                            StretchMode.zoomBackground,
                            StretchMode.blurBackground,
                            StretchMode.fadeTitle,
                          ],
                          centerTitle: true,
                          title: Text(state.merchant.name),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
          //                  Image.network(
          //                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
          //                    fit: BoxFit.cover,
          //                  ),
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.0, 0.5),
                                    end: Alignment(0.0, 0.0),
                                    colors: <Color>[
                                      Color(0x60000000),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                             AmountEntry("Monto:"),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else {
                  return SplashScreen();
                }
              }
          )
      ),
    );
  }
}

