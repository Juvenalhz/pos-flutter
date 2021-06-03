import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';

class MessageOkScreen extends StatelessWidget {
  final String title;
  final String message;
  final Function(BuildContext) onClickFunction;

  MessageOkScreen(this.title, this.message, this.onClickFunction);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              onPressed: () {
                onClickFunction(context);
              },
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              splashColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                //side: BorderSide(color: Colors.blueGrey)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
