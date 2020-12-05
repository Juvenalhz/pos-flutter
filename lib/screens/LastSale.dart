import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/bloc/lastSaleBloc.dart';
import 'package:pay/screens/transMessage.dart';

import 'LastSaleDetail.dart';
import 'commProgress.dart';
import 'components/CommError.dart';

class LastSale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LastSaleBloc lastSaleBloc = BlocProvider.of<LastSaleBloc>(context);
    Comm comm;

    return WillPopScope(
      child: Container(
        child: BlocBuilder<CommBloc, CommState>(builder: (context, state) {
          if (state is CommLoaded) {
            comm = state.comm;
            return BlocBuilder<LastSaleBloc, LastSaleState>(builder: (context, state) {
              if (state is LastSaleInitial) {
                lastSaleBloc.add(LastSaleConnect(comm));
                return CommProgress('Consulta Última Venta').build(context);
              } else if (state is LastSaleConnecting)
                return CommProgress('Consulta Última Venta', status: 'Conectando').build(context);
              else if (state is LastSaleSending)
                return CommProgress('Consulta Última Venta', status: 'Enviando').build(context);
              else if (state is LastSaleReceiving)
                return CommProgress('Consulta Última Venta', status: 'Recibiendo').build(context);
              else if (state is LastSaleInitial)
                return CommProgress('Consulta Última Venta').build(context);
              else if (state is LastSaleShowMessage)
                return TransMessage(state.message);
              else if (state is LastSaleCompleted) {
                return LastSaleDetail(state.trans, onClickDone);
              }
              else if (state is LastSaleFailed) {
                return LastSaleFinalScreen(state.message, false, onClickDone);
              }
              else if (state is LastSaleCommError)
                return CommError('Consulta Última Venta', 'Error de conexión....', onClickDone, onClickRetry);
              else {
                return CommProgress('Consulta Última Venta200').build(context);
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
    final LastSaleBloc lastSaleBloc = BlocProvider.of<LastSaleBloc>(context);

    lastSaleBloc.add(LastSaleInitialEvent());
  }

}

class LastSaleFinalScreen extends StatelessWidget {
  final String message;
  final bool approved;
  final Function(BuildContext) onClick;

  LastSaleFinalScreen(this.message, this.approved, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            if (approved)
              Image.asset('assets/images/icon_success.png')
            else
              Image.asset('assets/images/icon_failure.png'),
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
