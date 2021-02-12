import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/batchBloc.dart';
import 'package:pay/screens/WarningScreen.dart';
import 'package:pay/screens/askOkCancel.dart';
import 'package:pay/screens/commProgress.dart';
import 'package:pay/screens/components/CommError.dart';
import 'package:pay/screens/transMessage.dart';

class Batch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    return BlocListener<BatchBloc, BatchState>(listener: (context, state) {
      if (state is BatchFinish) Navigator.of(context).pop();
    }, child: Container(child: BlocBuilder<BatchBloc, BatchState>(builder: (context, state) {
      if (state is BatchEmpty)
        return WarningScreen('Cierre De Lote', 'Lote Vacio', onClickWarningEmpty);
      else if (state is BatchMissingTipAdjust) {
        return WarningScreen('Cierre De Lote', 'Faltan Propinas\n Por Ingresar', onClickWarningMissingTips);
      } else if (state is BatchConfirm) {
        return askOkCancel('Cierre De Lote', 'Confirmar Cierre', onClickOkConfirm, onClickCancel);
      } else if (state is BatchShowMessage) {
        return TransMessage(state.message);
      } else if (state is BatchConnecting) {
        return CommProgress('Cierre De Lote', status: 'Conectando').build(context);
      } else if (state is BatchSending) {
        return CommProgress('Cierre De Lote', status: 'Enviando').build(context);
      } else if (state is BatchReceiving) {
        return CommProgress('Cierre De Lote', status: 'Recibiendo').build(context);
      } else if (state is BatchCommError) {
        return CommError('Cierre De Lote', 'Error de conexión....', onClickCancel, onClickRetry);
      } else
        return Container();
    })));
  }

  void onClickWarningEmpty(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchCancel());
  }

  void onClickWarningMissingTips(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchMissingTipsOk());
  }

  void onClickOkConfirm(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchConfirmOk());
  }

  void onClickCancel(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchCancel());
  }

  void onClickRetry(BuildContext context) {
    final BatchBloc tipAdjustBloc = BlocProvider.of<BatchBloc>(context);
    tipAdjustBloc.add(BatchConnect());
  }
}
