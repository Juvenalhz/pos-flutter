import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/bloc/transaction/transaction_bloc.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/utils/printer.dart';

class Receipt {
  final BuildContext context;
  bool type;

  Receipt(this.context);

  printTransactionReceipt(bool type, Trans trans) {
    Printer printer = new Printer();

    this.type = type;
    if (type)
      printer.addText(Printer.CENTER, 'Merchant Receipt');
    else
      printer.addText(Printer.CENTER, 'Customer Receipt');

    printer.feedLine(2);

    printer.print(onPrintReceiptOK, onPrintError);
  }

  void onPrintReceiptOK() {
    final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if (this.type)
      transactionBloc.add(TransCustomerReceipt());
    else
      transactionBloc.add(TransCustomerReceipt());
  }

  void onPrintError(int error) {
    print('onPrintError:' + error.toString());
  }

  printTransactionReceiptCopy(bool type, Trans trans) {
    Printer printer = new Printer();

    this.type = type;
    if (type)
      printer.addText(Printer.CENTER, 'Merchant Receipt');
    else
      printer.addText(Printer.CENTER, 'Customer Receipt');

    printer.feedLine(2);
  }
}
