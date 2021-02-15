import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/batchBloc.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/bloc/totalsReportBloc.dart';
import 'package:pay/screens/WarningScreen.dart';
import 'package:pay/screens/askOkCancel.dart';
import 'package:pay/screens/commProgress.dart';
import 'package:pay/screens/components/CommError.dart';
import 'package:pay/screens/transMessage.dart';

class Batch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    return BlocListener<BatchBloc, BatchState>(listener: (context, state) async {
      if (state is BatchFinish) {
        Navigator.of(context).pop();
      } else if (state is BatchPrintDetailReport) {
        final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);
        final TotalsReportBloc totalsReportBloc = BlocProvider.of<TotalsReportBloc>(context);

        detailReportBloc.add(DetailReportPrintReport(context, printFromBatch: true));
        await Navigator.pushNamed(context, '/DetailReport');

      }
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
      } else if (state is BatchNotInBalance) {
        return WarningScreen('Cierre De Lote', 'Lote No Conciliado', onClickBatchFinish);
      } else if (state is BatchNotInBalance) {
        return WarningScreen('Cierre De Lote', 'Lote No Conciliado', onClickBatchFinish);
      } else if (state is BatchOK) {
        return BatchFinalScreen(state.message, onClickBatchFinish);
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

  void onClickBatchFinish(BuildContext context) {
    final BatchBloc batchBloc = BlocProvider.of<BatchBloc>(context);

    batchBloc.add(BatchComplete());
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

class BatchFinalScreen extends StatelessWidget {
  final String message;
  final Function(BuildContext) onClick;

  BatchFinalScreen(this.message, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/icon_success.png'),
            Spacer(),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Spacer(),
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
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
