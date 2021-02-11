import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/batchBloc.dart';
import 'package:pay/screens/askOkCancel.dart';

class Batch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    return BlocListener<BatchBloc, BatchState>(
        listener: (context, state) {},
        child: Container(child: BlocBuilder<BatchBloc, BatchState>(builder: (context, state) {
          if (state is BatchMissingTipAdjust) {
            return askOkCancel('Cierre De Lote', 'Faltan Propinas Por Ingresar', '¿Continuar con el Cierre?', onClickOkTips, onClickCancel);
          } else
            return Container();
        })));
  }

  void onClickOkTips(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchMissingTipsOk());
  }

  void onClickCancel(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchCancel());
  }
}
