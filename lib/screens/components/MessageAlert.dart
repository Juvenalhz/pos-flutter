import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageAlert extends StatelessWidget {
  final String _title;
  final String _msg;

  MessageAlert(
      this._title,
      this._msg, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this._title,
        style: TextStyle(color: Color(0xFF0D47A1)),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(this._msg),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'OK',
            style: TextStyle(color: Color(0xFF0D47A1)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
