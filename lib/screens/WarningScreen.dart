import 'package:flutter/material.dart';
import 'package:pay/models/trans.dart';

class WarningScreen extends StatelessWidget {
  final String title;
  final String message;
  final Function(BuildContext) onClickFunction;

  WarningScreen(this.title, this.message, this.onClickFunction);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/images/icon_warning.png'),
            Text(
              title,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(children: [
                  Flexible(
                      child: Center(child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)))),
                ])),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              onPressed: () {
                onClickFunction(context);
              },
              color: Colors.orange,
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
