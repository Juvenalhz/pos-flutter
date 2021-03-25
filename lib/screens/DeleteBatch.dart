import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/deleteBatchBloc.dart';
import 'package:pay/screens/QuestionYesNo.dart';
import 'package:pay/screens/transMessage.dart';

import 'components/MessageAlert.dart';

class DeleteBatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteBatchBloc, DeleteBatchState>(listener: (context, state) {
      if (state is DeleteBatchExit) {
        Navigator.of(context).pop();
      }
    }, child: Container(child: BlocBuilder<DeleteBatchBloc, DeleteBatchState>(builder: (context, state) {
      if (state is DeleteBatchNotExist) {
        return MessageAlert('Borrar Lote', 'No existen transacciones en el lote').build(context);
      } else if (state is DeleteBatchAskDelete) {
        return QuestionYesNo("Confirmación", 'Borrar Lote?', onClickEnter, onClickCancel);
      } else if (state is DeleteBatchDone) {
        return MessageAlert('Borrar Lote:', 'Lote Borrado', fontSize: 22.0).build(context);
      } else {
        return TransMessage('Procesando');
      }
    })));
  }

  void onClickEnter(BuildContext context) {
    final DeleteBatchBloc deleteReversalBloc = BlocProvider.of<DeleteBatchBloc>(context);

    deleteReversalBloc.add(DeleteBatchOK());
  }

  void onClickCancel(BuildContext context) {
    final DeleteBatchBloc deleteReversalBloc = BlocProvider.of<DeleteBatchBloc>(context);

    deleteReversalBloc.add(DeleteBatchCancel());
  }
}
