import 'package:flutter/material.dart';
import 'package:pay/models/trans.dart';

class TransRejectedScreen extends StatelessWidget {
  final Trans trans;

  TransRejectedScreen(this.trans);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/images/icon_failure.png'),
            Text(
              "Denegada",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(children: [
                Flexible(child: Center(child: Text(trans.respMessage, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)))),
              ])
            ),

            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.red,
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
