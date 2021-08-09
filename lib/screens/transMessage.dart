import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';

class TransMessage extends StatelessWidget {
  final String message;

  TransMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowMessage extends StatelessWidget {
  final String message;

  ShowMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransMessageEntryCard extends StatelessWidget{
  final String message;

  TransMessageEntryCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  CircularProgressIndicator(),

                ],
              ),
            ),
            Positioned(
              bottom: 40,
              right: 15,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(

                        child: Row(
                            children: [
                              Icon(Icons.keyboard, size: 20, color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Entrada\nManual',
                                  style: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: 'RobotoMono'),
                                ),
                              ),
                            ]),

                        onPressed: () {
                          final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

                          transactionBloc.add(TransCardReadManual());
                        },
                        color: Colors.blue,
                        padding: EdgeInsets.all(15.0),
                        splashColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ] ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
