import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/initialization/initialization_bloc.dart';

class CommError extends StatelessWidget {
  final String _title;
  final String _msg;
  final Function(BuildContext) onClickCancel;
  final Function(BuildContext) onClickRetry;

  CommError(this._title, this._msg, this.onClickCancel, this.onClickRetry);

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
            'Cancelar',
            style: TextStyle(color: Color(0xFF0D47A1)),
          ),
          onPressed: () {
            onClickCancel(context);
          },
        ),
        FlatButton(
          child: Text(
            'Re-intentar',
            style: TextStyle(color: Color(0xFF0D47A1)),
          ),
          onPressed: () {
            onClickRetry(context);
          },
        ),
      ],
    );
  }
}
