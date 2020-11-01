import 'package:flutter/material.dart';
import 'package:pay/models/trans.dart';

class TransStatusScreen extends StatelessWidget {
  final Trans trans;

  TransStatusScreen(this.trans);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/images/icon_success.png'),
            Text(
              "Aprobado",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
