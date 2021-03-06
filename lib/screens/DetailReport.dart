import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/detailReportBloc.dart';
import 'package:pay/bloc/transactionBloc.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/screens/transMessage.dart';
import 'package:pay/utils/pinpad.dart';
import 'package:pay/utils/spear_menu.dart';

import 'LastSaleDetail.dart';
import 'components/AlertCancelRetry.dart';

class DetailReport extends StatelessWidget {
  final List<String> menuListWithVoid = new List<String>.of(['Ver Detalles', 'Copia del Comercio', 'Copia del Cliente', 'Anulación']);
  final List<String> menuList = new List<String>.of(['Ver Detalles', 'Copia del Comercio', 'Copia del Cliente']);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              BlocListener<DetailReportBloc, DetailReportState>(
                listener: (context, state) {
                  if (state is DetailReportPrintOk) {
                    if (state.printFromBatch) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                  if ((state is DetailReportDataReady) || (state is DetailReportShowTransDetail)) {
                    return Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.6),
                          end: Alignment(0.0, 0.0),
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Colors.blue,
                          ],
                        ),
                      ),
                      child: Center(child: BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                        if (state is DetailReportDataReady) {
                          return Row(children: [
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Reporte Detallado',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                              if (state is DetailReportDataReady) {
                                if (state.transList.length > 0)
                                  return IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.print_outlined),
                                    onPressed: () {
                                      final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

                                      detailReportBloc.add(DetailReportPrintReport(false));
                                    },
                                  );
                                else
                                  return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                              } else
                                return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                            }),
                          ]);
                        } else if (state is DetailReportShowTransDetail) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Detalle De Transacción',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          );
                        } else {
                          return Text('');
                        }
                      })),
                    );
                  } else if (state is DetailReportVoidCheckPassword) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Anulación',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    );
                  } else
                    return Container();
                }),
              ),
            ]),
            Expanded(
                child: Stack(children: <Widget>[
              Container(
                color: Color(0xFF0D47A1),
              ),
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)), color: Colors.white),
                  child: BlocBuilder<DetailReportBloc, DetailReportState>(builder: (context, state) {
                    if (state is DetailReportDataReady) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 1, 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text('Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    Spacer(flex: 2),
                                    Text('No. Tarjeta', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Spacer(flex: 3),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      child: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Spacer(flex: 3),
                                    Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Spacer(flex: 3),
                                    Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Spacer(flex: 4),
                                    Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Spacer(flex: 5),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: new ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.transList.length,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                GlobalKey btnKey = GlobalKey();
                                Trans trans = state.transList[index];
                                return Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 4, 10, 2),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              key: btnKey,
                                              splashColor: Colors.blueAccent.withAlpha(180),
                                              child: Icon(Icons.more_vert_outlined),
                                              onTap: () {
                                                if ((trans.type == 'Anulación') || (trans.voided))
                                                  menuData(trans.id, btnKey, context, false);
                                                else
                                                  menuData(trans.id, btnKey, context, true);
                                              },
                                            ),
                                            Spacer(flex: 1),
                                            Text(trans.id.toString(), style: TextStyle(fontWeight: FontWeight.normal)),
                                            Spacer(flex: 6),
                                            SizedBox(
                                              width: 100,
                                              child: Text(trans.maskedPAN,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontFeatures: [FontFeature.tabularFigures()],
                                                  )),
                                            ),
                                            Spacer(flex: 2),
                                            SizedBox(
                                              width: 100,
                                              child: Text(formatter.format(trans.total / 100),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontFeatures: [FontFeature.tabularFigures()],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                                        child: Row(
                                          children: [
                                            Spacer(flex: 1),
                                            SizedBox(width: 70, child: Text(trans.type, style: TextStyle(fontWeight: FontWeight.normal))),
                                            Spacer(flex: 1),
                                            SizedBox(
                                                width: 90,
                                                child: Text(DateFormat('dd/MM/yyyy').format(trans.dateTime),
                                                    textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.normal))),
                                            Spacer(flex: 1),
                                            Text(DateFormat('hh:mm:ss').format(trans.dateTime), style: TextStyle(fontWeight: FontWeight.normal)),
                                            Spacer(flex: 3),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (state is DetailReportShowTransDetail) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(flex: 1),
                          Text(state.trans.type + ' - ' + state.cardBrand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                          Spacer(flex: 1),
                          RowDetail(
                              label: DateFormat('dd/MM/yyyy').format(state.trans.dateTime),
                              strAmount: DateFormat('hh:mm:ss').format(state.trans.dateTime)),
                          Spacer(flex: 1),
                          RowDetail(label: "Ticket:", strAmount: state.trans.numticket.toString()),
                          Spacer(flex: 2),
                          RowDetailAmount(label: "Total:", strAmount: formatter.format(state.trans.total / 100)),
                          Spacer(flex: 2),
                          RowDetail(label: "Tarjeta:", strAmount: state.trans.maskedPAN),
                          Spacer(flex: 1),
                          RowDetail(label: "Autorización:", strAmount: state.trans.authCode),
                          Spacer(flex: 1),
                          RowDetail(label: "Referencia:", strAmount: state.trans.referenceNumber),
                          Spacer(flex: 2),
                          if (state.trans.respCode == '00') btnEnter(context, true) else btnEnter(context, false),
                          Spacer(flex: 1),
                        ],
                      );
                    } else if (state is DetailReportPrinting) {
                      return TransMessage('Imprimiendo Reporte Detallado');
                    } else if (state is DetailReportPrintError) {
                      return AlertCancelRetry('Impresión', 'Error en impresión de reporte....', onPrintCancel, onPrintRetry);
                    } else if (state is DetailReportVoidCheckPassword) {
                      return LockScreen(
                          //context: context,
                          digits: state.terminal.password.length,
                          correctString: state.terminal.password,
                          title: 'Ingrese Clave De Supervisor',
                          cancelText: 'Cancelar',
                          deleteText: 'Borrar',
                          backgroundColorOpacity: 0.9,
                          onCompleted: (context, verifyCode) {
                            final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

                            detailReportBloc.add(DetailReportInitialEvent());
                          },
                          onUnlocked: () {
                            final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
                            Pinpad pinpad = new Pinpad(context);
                            //TODO: this pinpad instance for now is a work around, need a way to remove it as it will not be used
                            transactionBloc.add(TransInitPinpad(pinpad));
                            transactionBloc.add(TransVoidTransaction(state.id));
                            Navigator.pushNamed(context, '/transaction');
                          });
                    } else
                      return SplashScreen();
                  }))
            ])),
          ],
        ),
      ),
    );
  }

  void menuData(int id, GlobalKey btnKey, BuildContext context, bool withVoid) {
    List<MenuItemProvider> setData = new List<MenuItemProvider>();
    setData.clear();
    for (var io in (withVoid) ? menuListWithVoid : menuList) {
      setData.add(MenuItem(title: io));
    }

    SpearMenu menu = SpearMenu(
        //backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        items: setData,
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss,
        context: context,
        id: id);

    menu.show(widgetKey: btnKey);
  }

  Future<void> onClickMenu(MenuItemProvider item, int id, BuildContext context) async {
    final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

    print('Click menu -> ${item.menuTitle} - id:$id');
    if (item.menuTitle == 'Copia del Comercio') {
      detailReportBloc.add(DetailReportPrintReceiptCopy(false, id, context));
    } else if (item.menuTitle == 'Copia del Cliente') {
      detailReportBloc.add(DetailReportPrintReceiptCopy(true, id, context));
    } else if (item.menuTitle == 'Ver Detalles') {
      detailReportBloc.add(DetailReportViewTransDetail(id));
    } else if (item.menuTitle == 'Anulación') {
      TerminalRepository teminalRepository = new TerminalRepository();
      Terminal terminal = Terminal.fromMap(await teminalRepository.getTerminal(1));

      if (terminal.password.length > 0) {
        detailReportBloc.add(DetailReportVoidPassword(id, terminal));
      } else {
        final TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
        Pinpad pinpad = new Pinpad(context);
        //TODO: this pinpad instance for now is a work around, need a way to remove it as it will not be used
        transactionBloc.add(TransInitPinpad(pinpad));
        transactionBloc.add(TransVoidTransaction(id));
        Navigator.pushNamed(context, '/transaction');
      }
    }
  }

  void stateChanged(bool isShow) {
    //print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onDismiss() {
    //print('Menu is dismiss');
  }

  Widget btnEnter(BuildContext context, bool approved) {
    Color btnColor = (approved) ? Colors.green : Colors.red;
    IconData btnIcon = (approved) ? Icons.done_outline : Icons.error_outline;

    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: FlatButton(
        child: Icon(btnIcon, size: 35, color: Colors.white),
        onPressed: () {
          final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

          detailReportBloc.add(DetailReportInitialEvent());
        },
        color: btnColor,
        padding: EdgeInsets.all(15.0),
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.blueGrey)
        ),
      ),
    );
  }

  void onPrintCancel(BuildContext context) {
    final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

    detailReportBloc.add(DetailReportPrintCancel());
  }

  void onPrintRetry(BuildContext context) {
    final DetailReportBloc detailReportBloc = BlocProvider.of<DetailReportBloc>(context);

    detailReportBloc.add(DetailReportPrintRetry());
  }
}
