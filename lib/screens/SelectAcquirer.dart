import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/acquirerBloc.dart';
import 'package:pay/bloc/merchantBloc.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/screens/selectionMenu.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/models/acquirer.dart';

class SelectAcquirer extends StatelessWidget {
  int _selectedAcquirer;
  Merchant _merchant;

  @override
  Widget build(BuildContext context) {
    AcquirerRepository acquirerRepository = new AcquirerRepository();

    return BlocBuilder<MerchantBloc, MerchantState>(builder: (context, state) {
      if (state is MerchantLoaded) {
        final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);
        _merchant = state.merchant;
        _selectedAcquirer = _merchant.acquirerCode;
        acquirerBloc.add(GetAllAcquirer());
        return BlocListener<AcquirerBloc, AcquirerState>(listener: (context, state) {
          if (state is AcquirerSelectionExit) {
            Navigator.of(context).pop();
          }
        }, child: Container(child: BlocBuilder<AcquirerBloc, AcquirerState>(builder: (context, state) {
          if (state is AcquirerGetAll) {
            LinkedHashMap<int, String> list = new LinkedHashMap<int, String>();
            int i = 0;

            state.acquirerList.forEach((value) {
              Acquirer acquirer = Acquirer.fromMap(value);

              list.putIfAbsent(acquirer.id, () => acquirer.name);
            });

            return SafeArea(
              child: Scaffold(
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
                        child: Stack(
                          children: <Widget>[
                            Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Seleccionar Adquirente',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                          ),
                                        ],
                                      ),
                                    )))
                          ],
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(flex: 1),
                              SelectionMenu('', list, false, selectedItem: _selectedAcquirer, onSelection: onAcquirerSelection),
                              Spacer(flex: 1),
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnEnter(context)]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
                  ],
                ),
              ),
            );
          } else
            return SplashScreen();
        })));
      }

      else if (state is AcquirerSelect) {
        final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);
        _merchant = state.merchant;
        _selectedAcquirer = _merchant.acquirerCode;
        acquirerBloc.add(GetAllAcquirer());
        return BlocListener<AcquirerBloc, AcquirerState>(listener: (context, state) {
          if (state is AcquirerSelectionExit) {
            Navigator.of(context).pop();
          }
        }, child: Container(child: BlocBuilder<AcquirerBloc, AcquirerState>(builder: (context, state) {
          if (state is AcquirerGetAll) {
            LinkedHashMap<int, String> list = new LinkedHashMap<int, String>();
            int i = 0;

            state.acquirerList.forEach((value) {
              Acquirer acquirer = Acquirer.fromMap(value);

              list.putIfAbsent(acquirer.id, () => acquirer.name);
            });

            return SafeArea(
              child: Scaffold(
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
                        child: Stack(
                          children: <Widget>[
                            Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Seleccionar Adquirente',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                          ),
                                        ],
                                      ),
                                    )))
                          ],
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
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(flex: 1),
                                  SelectionMenu('', list, false, selectedItem: _selectedAcquirer, onSelection: onAcquirerSelection),
                                  Spacer(flex: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnEnter(context)]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])),
                  ],
                ),
              ),
            );
          } else
            return SplashScreen();
        })));
      }

      else
        return SplashScreen();
    });
  }

  Widget btnCancel(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.cancel, size: 35, color: Colors.white),
        onPressed: () {
          final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);
          acquirerBloc.add(AcquirerSelectionFinish());
        },
        color: Colors.red,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  Widget btnEnter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () async {
          if (_selectedAcquirer != _merchant.acquirerCode) {
            MerchantRepository merchantRepository = new MerchantRepository();
            final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
            final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);

            // AcquirerRepository acquirerRepository = new AcquirerRepository();
            // Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(0));
            // acquirer.industryType = true;
            // await acquirerRepository.updateacquirer(acquirer);
            // acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(1));
            // acquirer.industryType = true;
            // await acquirerRepository.updateacquirer(acquirer);
            // acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(2));
            // acquirer.industryType = true;
            // await acquirerRepository.updateacquirer(acquirer);

            _merchant.acquirerCode = _selectedAcquirer;
            await merchantRepository.updateMerchant(_merchant);
            merchantBloc.add(GetMerchant(1));

            acquirerBloc.add(AcquirerSelectionFinish());
            acquirerBloc.add(GetAcquirer(_selectedAcquirer));
          }
        },
        color: Colors.green,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  void onAcquirerSelection(BuildContext context, int value) {
    _selectedAcquirer = value;
  }
}
