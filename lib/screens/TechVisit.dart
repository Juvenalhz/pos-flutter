import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/TechVisitBloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/screens/AskNumeric.dart';
import 'package:pay/screens/transMessage.dart';
import 'package:pay/utils/pinpad.dart';

import 'commProgress.dart';
import 'components/CommError.dart';

class TechVisit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TechVisitBloc techVisitBloc = BlocProvider.of<TechVisitBloc>(context);
    Comm comm;
    Pinpad pinpad = new Pinpad(context);

    return WillPopScope(
      child: Container(
        child: BlocBuilder<CommBloc, CommState>(builder: (context, state) {
          if (state is CommLoaded) {
            comm = state.comm;
            return BlocBuilder<TechVisitBloc, TechVisitState>(builder: (context, state) {
              if (state is TechVisitInitial) {
                //techVisitBloc.add(TechVisitConnect(comm));
                techVisitBloc.add(TechVisitInitPinpad(pinpad));
                return CommProgress('Conformidad De Visita').build(context);
              } else if (state is TechVisitGetCard) {
                return ShowMessage('Visita Técnica Deslice Tarjeta De Técnico');
              } else if (state is TechVisitAskVisitType) {
                return AskVisitType('Tipo', 'De Atención', '', 1, 2, AskNumeric.NO_DECIMALS, onClickVisitTypeEnter, onClickVisitTypeBack);
              } else if (state is TechVisitAskRequirementType)
                return AskRequirementType(
                    'Tipo', 'De Requerimiento', '', 1, 9, AskNumeric.NO_DECIMALS, onClickRequirementTypeEnter, onClickRequirementTypeBack);
              else if (state is TechVisitShowPinMessage)
                return PinEntryMessage('Ingresa Clave De Técnico');
              else if (state is TechVisitConnecting)
                return CommProgress('Conformidad De Visita', status: 'Conectando').build(context);
              else if (state is TechVisitSending)
                return CommProgress('Conformidad De Visita', status: 'Enviando').build(context);
              else if (state is TechVisitReceiving)
                return CommProgress('Conformidad De Visita', status: 'Recibiendo').build(context);
              else if (state is TechVisitInitial)
                return CommProgress('Conformidad De Visita').build(context);
              else if (state is TechVisitShowMessage)
                return TransMessage(state.message);
              else if (state is TechVisitCompleted) {
                 return TechVisitFinalScreen(state.message, true, onClickDone);
              }
              else if (state is TechVisitFailed) {
                return TechVisitFinalScreen(state.message, false, onClickDone);
              } else if (state is TechVisitCommError)
                return CommError('Conformidad De Visita', 'Error de conexión....', onClickDone, onClickRetry);
              else {
                return CommProgress('Conformidad De Visita').build(context);
              }
            });
          } else
            return CommProgress('Conformidad De Visita').build(context);
        }),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  void onClickVisitTypeEnter(BuildContext context, int value) {
    final TechVisitBloc techVisitBloc = BlocProvider.of<TechVisitBloc>(context);

    techVisitBloc.add(TechVisitAddVisitType(value));
  }

  void onClickVisitTypeBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onClickRequirementTypeEnter(BuildContext context, int value) {
    final TechVisitBloc techVisitBloc = BlocProvider.of<TechVisitBloc>(context);

    techVisitBloc.add(TechVisitAddRequirementType(value));
  }

  void onClickRequirementTypeBack(BuildContext context) {
    final TechVisitBloc techVisitBloc = BlocProvider.of<TechVisitBloc>(context);

    techVisitBloc.add(TechVisitAddRequirementBack());
  }

  void onClickDone(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onClickRetry(BuildContext context) {
    final TechVisitBloc lastSaleBloc = BlocProvider.of<TechVisitBloc>(context);

    lastSaleBloc.add(TechVisitInitialEvent());
  }
}

class TechVisitFinalScreen extends StatelessWidget {
  final String message;
  final bool approved;
  final Function(BuildContext) onClick;

  TechVisitFinalScreen(this.message, this.approved, this.onClick);

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

class PinEntryMessage extends StatelessWidget {
  final String message;

  PinEntryMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 90),
            Center(
              child: Text(
                message,
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
    );
  }
}
