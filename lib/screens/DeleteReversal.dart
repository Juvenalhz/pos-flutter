import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/deleteReversal/delete_reversal_bloc.dart';
import 'package:pay/screens/QuestionYesNo.dart';
import 'package:pay/screens/transMessage.dart';

import 'components/MessageAlert.dart';

class DeleteReversal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocListener<DeleteReversalBloc, DeleteReversalState>(
        listener: (context, state) {
          if (state is DeleteReversalExit) {
            Navigator.of(context).pop();
          }
        },
        child:
        Container(
        child:
          BlocBuilder<DeleteReversalBloc, DeleteReversalState>(builder: (context, state) {
          if (state is DeleteReversalNotExist) {
            return MessageAlert('Borrar Reverso', 'No existe reverso pendiente').build(context);
          }
          else if (state is DeleteReversalAskDelete){
            return QuestionYesNo("Reverso", 'Borrar reverso Pendiente?', onClickEnter, onClickCancel);
          }
          else if (state is DeleteReversalDone) {
            return MessageAlert('Borrar Reverso', 'Reverso pendiente borrado').build(context);
          }
          else {
            return TransMessage('Procesando');
          }
        }
       )
    )
    );
  }

  void onClickEnter(BuildContext context) {
    final DeleteReversalBloc deleteReversalBloc = BlocProvider.of<DeleteReversalBloc>(context);

    deleteReversalBloc.add(DeleteReversalOK());
  }

  void onClickCancel(BuildContext context) {
    final DeleteReversalBloc deleteReversalBloc = BlocProvider.of<DeleteReversalBloc>(context);

    deleteReversalBloc.add(DeleteReversalCancel());
  }
}

