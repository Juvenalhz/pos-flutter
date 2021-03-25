import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/acquirerBloc.dart';
import 'package:pay/bloc/comm/comm_bloc.dart';
import 'package:pay/bloc/comm/comm_event.dart';
import 'package:pay/bloc/comm/comm_state.dart';
import 'package:pay/bloc/emv/emv_bloc.dart';
import 'package:pay/bloc/emv/emv_event.dart';
import 'package:pay/bloc/merchant/merchant_bloc.dart';
import 'package:pay/bloc/merchant/merchant_event.dart';
import 'package:pay/bloc/terminal/terminal_bloc.dart';
import 'package:pay/bloc/terminal/terminal_event.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/screens/commProgress.dart';
import 'package:pay/bloc/initializationBloc.dart';
import 'components/AlertCancelRetry.dart';

class Initialization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final InitializationBloc initializationBloc = BlocProvider.of<InitializationBloc>(context);
    Comm comm;

    return WillPopScope(
      child: Container(
        child: BlocBuilder<CommBloc, CommState>(builder: (context, state) {
          if (state is CommLoaded) {
            comm = state.comm;
            return BlocBuilder<InitializationBloc, InitializationState>(builder: (context, state) {
              if (state is InitializationInitial) {
                initializationBloc.add(InitializationConnect(comm));
                return CommProgress('Inicialización').build(context);
              } else if (state is InitializationConnecting)
                return CommProgress('Inicialización', status: 'Conectando').build(context);
              else if (state is InitializationSending)
                return CommProgress('Inicialización', status: 'Enviando').build(context);
              else if (state is InitializationReceiving)
                return CommProgress('Inicialización', status: 'Recibiendo').build(context);
              else if (state is InitializationInitial)
                return CommProgress('Inicialización').build(context);
              else if (state is InitializationCompleted) {
                return InitializationAlert('Inicialización', 'Proceso de inicialización completado');
              }
              else if (state is InitializationFailed) {
                final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
                final TerminalBloc terminalBloc = BlocProvider.of<TerminalBloc>(context);
                final CommBloc commBloc = BlocProvider.of<CommBloc>(context);
                final EmvBloc emvBloc = BlocProvider.of<EmvBloc>(context);
                final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);

                merchantBloc.add(GetMerchant(1));
                terminalBloc.add(GetTerminal(1));
                commBloc.add(GetComm(1));
                emvBloc.add(GetEmv(1));
                acquirerBloc.add(GetAcquirer(1));
                return InitializationAlert('Inicialización', 'Proceso de inicialización falló, intente de nuevamente...');
              }
              else if (state is InitializationCommError)
                return AlertCancelRetry('Inicialización', 'Error de conexión....', onClickCancel, onClickRetry);
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

  void onClickCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onClickRetry(BuildContext context) {
    final InitializationBloc initializationBloc = BlocProvider.of<InitializationBloc>(context);

    initializationBloc.add(InitializationInitialEvent());
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
          onPressed: () async {
            final MerchantBloc merchantBloc = BlocProvider.of<MerchantBloc>(context);
            final TerminalBloc terminalBloc = BlocProvider.of<TerminalBloc>(context);
            final CommBloc commBloc = BlocProvider.of<CommBloc>(context);
            final EmvBloc emvBloc = BlocProvider.of<EmvBloc>(context);
            final AcquirerBloc acquirerBloc = BlocProvider.of<AcquirerBloc>(context);
            MerchantRepository merchantRepository = new MerchantRepository();
            Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));

            merchantBloc.add(GetMerchant(1));
            terminalBloc.add(GetTerminal(1));
            commBloc.add(GetComm(1));
            emvBloc.add(GetEmv(1));
            acquirerBloc.add(GetAcquirer(merchant.acquirerCode));

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
