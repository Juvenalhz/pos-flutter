import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/screens/commProgress.dart';
import 'package:pay/bloc/initializationBloc.dart';

class Initialization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final InitializationBloc initializationBloc = BlocProvider.of<InitializationBloc>(context);
    final CommBloc commBloc = BlocProvider.of<CommBloc>(context);

    return WillPopScope(
      child: Container(
        child: BlocBuilder<CommBloc, CommState>(builder: (context, state) {
          if (state is CommLoaded) {
            initializationBloc.add(InitializationConnect(state.comm));
            return BlocBuilder<InitializationBloc, InitializationState>(builder: (context, state) {
              if (state is InitializationConnecting)
                return CommProgress('Inicialización', status: 'Conectando').build(context);
              else if (state is InitializationSending)
                return CommProgress('Inicialización', status: 'Enviando').build(context);
              else if (state is InitializationReceiving)
                return CommProgress('Inicialización', status: 'Recibiendo').build(context);
              else if (state is InitializationInitial)
                return CommProgress('Inicialización').build(context);
              else if (state is InitializationCompleted)
                return InitializationAlert('Inicialización', 'Proceso de inicialización completado');
              else if (state is InitializationFailed)
                return InitializationAlert('Inicialización', 'Proceso de inicialización falló, intente de nuevamente...');
              else {
                return CommProgress('Inicialización').build(context);
              }
            });
          } else
            return CommProgress('Inicialización').build(context);
        }),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

class InitializationAlert extends StatelessWidget {
  final String _title;
  final String _msg;

  InitializationAlert(
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
