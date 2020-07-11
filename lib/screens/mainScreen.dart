import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/bloc.dart';
import 'package:pay/bloc/merchant_bloc.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/database.dart';

import 'amount.dart';

class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

    merchantBloc.add(GetMerchant(1));

    return Scaffold(
        body:
        BlocBuilder<MerchantBloc, MerchantState>(
            //bloc: BlocProvider.of<MerchantBloc>(context),
            // ignore: missing_return
            builder: (context, state){
              if (state is MerchantLoaded){
                return  CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      leading: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            print('menu selected');
                          },
                        ),
                      ),
                      stretch: true,
                      onStretchTrigger: () {
                        // Function callback for stretch
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
                          new AmountEntry(),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else {

                  //merchantBloc.add(GetMerchant(0));
                    return SplashScreen();
              }
            }
        )
    );
  }

}

class MainScreen_old extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen_old> {

  final appdb = DatabaseHelper.instance;
  String storeName = '';

  @override
  State<StatefulWidget> createState() {}

  @override
  Widget build(BuildContext context) {
    final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);

    return Scaffold(
      body:
        BlocConsumer<MerchantBloc, MerchantState>(
          listener: (context, state){
          },
          // ignore: missing_return
          builder: (context, state){
            if (state is MerchantInitial)
              return SplashScreen();
            else if (state is MerchantLoaded){
              return  CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    leading: Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          print('menu selected');
                        },
                      ),
                    ),
                    stretch: true,
                    onStretchTrigger: () {
                      // Function callback for stretch
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
                        new AmountEntry(),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        )
    );
  }
}
