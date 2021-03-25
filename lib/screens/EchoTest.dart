import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/bloc/echotestBloc.dart';
import 'package:pay/screens/transMessage.dart';

import 'commProgress.dart';
import 'components/AlertCancelRetry.dart';

class EchoTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EchoTestBloc echoTestBloc = BlocProvider.of<EchoTestBloc>(context);
    Comm comm;

    return WillPopScope(
      child: Container(
        child: BlocBuilder<CommBloc, CommState>(builder: (context, state) {
          if (state is CommLoaded) {
            comm = state.comm;
            return BlocBuilder<EchoTestBloc, EchoTestState>(builder: (context, state) {
              if (state is EchoTestInitial) {
                echoTestBloc.add(EchoTestConnect(comm));
                return CommProgress('Prueba De Comunicación').build(context);
              } else if (state is EchoTestConnecting)
                return CommProgress('Prueba De Comunicación', status: 'Conectando').build(context);
              else if (state is EchoTestSending)
                return CommProgress('Prueba De Comunicación', status: 'Enviando').build(context);
              else if (state is EchoTestReceiving)
                return CommProgress('Prueba De Comunicación', status: 'Recibiendo').build(context);
              else if (state is EchoTestInitial)
                return CommProgress('Prueba De Comunicación').build(context);
              else if (state is EchoTestShowMessage)
                return TransMessage(state.message);
              else if (state is EchoTestCompleted) {
                return EchoTestFinalScreen(state.message, true, onClickDone);
              } else if (state is EchoTestFailed) {
                return EchoTestFinalScreen(state.message, false, onClickDone);
              } else if (state is EchoTestCommError)
                return AlertCancelRetry('Prueba De Comunicación', 'Error de conexión....', onClickDone, onClickRetry);
              else {
                return CommProgress('Prueba De Comunicación').build(context);
              }
            });
          } else
            return CommProgress('Prueba De Comunicación').build(context);
        }),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  void onClickDone(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onClickRetry(BuildContext context) {
    final EchoTestBloc echoTestBloc = BlocProvider.of<EchoTestBloc>(context);

    echoTestBloc.add(EchoTestInitialEvent());
  }
}

class EchoTestFinalScreen extends StatelessWidget {
  final String message;
  final bool approved;
  final Function(BuildContext) onClick;

  EchoTestFinalScreen(this.message, this.approved, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            if (approved) Image.asset('assets/images/icon_success.png') else Image.asset('assets/images/icon_failure.png'),
            Spacer(),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Spacer(),
            if (approved)
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                onPressed: () {
                  onClick(context);
                },
                color: Colors.green,
                padding: EdgeInsets.all(15.0),
                splashColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //side: BorderSide(color: Colors.blueGrey)
                ),
              )
            else
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                onPressed: () {
                  onClick(context);
                },
                color: Colors.red,
                padding: EdgeInsets.all(15.0),
                splashColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //side: BorderSide(color: Colors.blueGrey)
                ),
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
