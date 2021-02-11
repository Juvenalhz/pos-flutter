import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';

class askOkCancel extends StatelessWidget {
  String title1;
  String title2;
  String message;
  Function(BuildContext) onClickOk;
  Function(BuildContext) onClickCancel;

  askOkCancel(this.title1, this.title2, this.message, this.onClickOk, this.onClickCancel);

  @override
  Widget build(BuildContext context) {
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
                child: Stack(children: <Widget>[
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 10, 0),
                        child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
                          if (state is TransactionAskConfirmation) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    title1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // this text should not be shown, as the state should always be correct, but we need to return a widget
                            return Text(
                              title2,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            );
                          }
                        })),
                  )
                ]),
              ),
            ]),
            Expanded(
                child: Stack(children: <Widget>[
              Container(
                color: Color(0xFF0D47A1),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(flex: 1),
                    Text(this.message, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                    Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btnCancel(context), btnEnter(context)]),
                    ),
                  ],
                )),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  Widget btnCancel(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.cancel, size: 35, color: Colors.white),
        onPressed: () {
          onClickCancel(context);
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
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(Icons.arrow_forward, size: 35, color: Colors.white),
        onPressed: () {
          onClickOk(context);
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
}
