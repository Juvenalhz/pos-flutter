import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/batch/batch_bloc.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/bloc/totalsReportBloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/screens/MessageOKScreen.dart';
import 'package:pay/screens/TransApprovedScreen.dart';
import 'package:pay/screens/Confirmation.dart';
import 'package:pay/screens/AskNumeric.dart';
import 'package:pay/screens/selectionMenu.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/screens/transMessage.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/screens/QuestionYesNo.dart';
import 'DigitalReceipt.dart';
import 'TipScreen.dart';
import 'TransRejectedScreen.dart';
import 'commProgress.dart';
import 'components/AlertCancelRetry.dart';
import 'mainScreen.dart';

class Transaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    Pinpad pinpad = new Pinpad(context);
    bool pinpadInit = false;

    return
      WillPopScope(
          onWillPop: () async {

             return true;},
        child: BlocListener<TransactionBloc, TransactionState>(listener: (context, state) {
      if ((state is TransactionFinish) || (state is TransactionError)) {
        if ((state is TransactionFinish) && (state.trans.type == 'Anulación')) {
          final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

          detailReportBloc.add(DetailReportInitialEvent());
        }
        Navigator.of(context).pop();
      }
    }, child: Container(
      child: BlocBuilder<TransactionBloc, TransactionState>(builder: (context, state) {
        if (pinpadInit == false) {
          transactionBloc.add(TransInitPinpad(pinpad));
          pinpadInit = true;
        }

        if (state is TransactionAddAmount) {
          return (MainScreen());
        } else if (state is TransactionAddTip) {
          return TipScreen(state.trans, onClickTipEnter, onClickTipBack);
        } else if (state is TransactionAskIdNumber) {
          return new AskID('Número', 'De Cédula', '', 6, 9, AskNumeric.NO_DECIMALS, onClickIDEnter, onClickIDBack);
        } else if (state is TransactionAskLast4Digits) {
          return new AskLast4('Ingrese', 'Ultimos 4 Digitos', '', 4, 4, AskNumeric.NO_SEPARATORS, onClickLast4Enter, onClickLast4Back);
        } else if (state is TransactionAskCVV) {
          return new AskCVV('Ingrese Código', 'De Seguridad', '', 3, 3, AskNumeric.NO_SEPARATORS, onClickCVVEnter, onClickCVVBack);
        } else if (state is TransactionAskServerNumber) {
          return new AskServer('Ingrese Número', 'De Mesero', '', 0, 2, AskNumeric.NO_SEPARATORS, onClickServerEnter, onClickServerBack);
        } else if (state is TransactionAskConfirmation) {
          return Confirmation(trans: state.trans);
        } else if (state is TransactionAskAccountType) {
          LinkedHashMap<int, String> accTypes = LinkedHashMap.from({0: 'Cuenta Corriente', 1: 'Ahorro'});
          return SelectionMenu("Seleccione Tipo de Cuenta", accTypes, false, onSelection: onAccTypeSelection);
        } else if (state is TransactionLoadEmvTable) {
          //transactionBloc.add(TransLoadEmvTables());
          print('show splash screen');
          return SplashScreen();
        } else if (state is TransactionWaitEmvTablesLoaded) {
          return TransMessage('Espere, por favor');
        } else if (state is TransactionShowMessage) {
          if (state.message != null) return TransMessage(state.message);
        } else if (state is TransactionShowEntryCard) {
          return TransMessageEntryCard(state.message);
        } else if (state is TransactionCardRead) {
          return TransMessage(state.trans.appLabel);
        } else if (state is TransactionAskAccountNumber) {
          return AskAccountNumber(
              'Ingrese', 'Numero De Tarjeta', '', 13, 19, AskNumeric.ACCOUNT, onClickAccountNumberEnter, onClickAccountNumberBack);
        } else if (state is TransactionAskExpDate) {
          return AskExpirationDate('Ingrese Fecha De', ' Vencimiento AA/MM', '', 4, 9999, AskNumeric.NO_SEPARATORS, onClickExpDateEnter, onClickExpDateBack);
        }
        else if (state is TransactionShowPinAmount) {
          return PinEntryMessage(state.trans);
        } else if (state is TransactionConnecting) {
          return CommProgress('Autorización', status: 'Conectando').build(context);
        } else if (state is TransactionSending) {
          return CommProgress('Autorización', status: 'Enviando').build(context);
        } else if (state is TransactionReceiving) {
          return CommProgress('Autorización', status: 'Recibiendo').build(context);
        } else if (state is TransactionCompleted) {
          return TransApprovedScreen(state.trans, onClickResponseMessage);
        } else if (state is TransactionRejected) {
          return TransRejectedScreen(state.trans, onClickResponseMessageError);
        } else if (state is TransactionPrintMerchantReceipt) {
          return TransMessage('Impresión De Recibo De Comercio');
        } else if (state is TransactionAskPrintCustomer) {
          return QuestionYesNo('Recibo', 'Imprimir Copia Del Cliente?', onPrintCustomer, onSkipCustomer);
        } else if (state is TransactionPrintCustomerReceipt) {
          return TransMessage('Impresión De Recibo De Cliente');
        } else if (state is TransactionCommError) {
          return AlertCancelRetry('Autorización', 'Error de conexión....', onClickCancel, onClickRetry);
        } else if (state is TransactionPrintMerchantError) {
          return AlertCancelRetry('Impresión', 'Error en impresión de recibo....', onPrintMerchantCancel, onPrintMerchantRetry);
        } else if (state is TransactionPrintCustomerError) {
          return AlertCancelRetry('Impresión', 'Error en impresión de recibo....', onPrintCustomerCancel, onPrintCustomerRetry);
        } else if (state is TransactionDigitalReceiptCustomer) {
          return DigitalReceipt(state.trans, state.acquierer, state.merchant, state.terminal);
        } else if (state is TransactionAutoCloseBatch) {
          return MessageOkScreen('Cierre De Lote', 'Se imprimirá Reporte de Lote Anterior', onCloseBatchOk);
        } else
          print('state:' + state.toString());
        return TransMessage('');
      }),
    )));
  }

  void onClickLast4Enter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddLast4(value));
  }

  void onClickLast4Back(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransLast4Back());
  }

  void onClickIDEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddIdNumber(value));
  }

  void onClickIDBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransIDBack());
  }

  void onClickCVVEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddCVV(value));
  }

  void onClickCVVBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCVVBack());
  }

  void onClickServerEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddServerNumber(value));
  }

  void onClickServerBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransServerBack());
  }

  void onAccTypeSelection(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (value == 0)
      transactionBloc.add(TransAddAccountType(2)); // checking account
    else if (value == 1) transactionBloc.add(TransAddAccountType(1)); // saving account
  }

  void onClickCancel(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCardError());
  }

  void onClickRetry(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransConnect());
  }

  void onClickTipBack(BuildContext context, Trans trans) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAskAmount(trans.baseAmount));
  }

  void onClickTipEnter(BuildContext context, int tip) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddTip(tip));
  }

  void onClickResponseMessage(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransRemoveCard());
  }

  void onClickResponseMessageError(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransRemoveCard());
  }

  void onPrintMerchantCancel(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransPrintMerchantOK());
  }

  void onPrintMerchantRetry(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransMerchantReceipt());
  }

  void onPrintCustomerCancel(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransPrintCustomerOK());
  }

  void onPrintCustomerRetry(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCustomerReceipt());
  }

  void onPrintCustomer(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCustomerReceipt());
  }

  void onSkipCustomer(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransPrintCustomerOK());
  }

  Future<void> onCloseBatchOk(BuildContext context) async {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    final TotalsReportBloc totalsReportBloc = BlocProvider.of<TotalsReportBloc>(context);

    totalsReportBloc.add(TotalsReportPrintReport(true));
    await Navigator.pushNamed(context, '/TotalsReport');

    transactionBloc.add(TransDeletePreviousBatch());
  }

  void onClickAccountNumberEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransAddAccountNumber(value.toString()));
  }

  void onClickAccountNumberBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransGetCard());
  }

  void onClickExpDateEnter(BuildContext context, int value) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    var exp = value.toString().length == 3 ? '0'+value.toString() : value.toString(); //Cuanto la fecha comienza en cero lo elimina por ser un entero, aca se agrega en cero en caso de que sea necesario.
    transactionBloc.add(TransAddExpDate(exp));
  }

  void onClickExpDateBack(BuildContext context) {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    transactionBloc.add(TransCardReadManual());
  }
}

class PinEntryMessage extends StatelessWidget {
  final Trans trans;

  PinEntryMessage(this.trans);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return Material(
      child: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 90),
            Center(
              child: Text(
                'Ingrese PIN:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 70),
            Center(
              child: Text(
                this.trans.type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                formatter.format(this.trans.total / 100),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
