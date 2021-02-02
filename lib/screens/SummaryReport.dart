import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/summaryReportBloc.dart';
import 'package:pay/screens/components/item_tile_two_column.dart';
import 'package:pay/screens/splash.dart';

class SummaryReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var formatter = new NumberFormat.currency(locale: 'eu', symbol: ' ', decimalDigits: 2);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
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
                child: Center(child: BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                  if (state is SummaryReportDataReady) {
                    return Row(children: [
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              'Resumen',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              'De Parámetros',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                        if (state is SummaryReportDataReady) {
                          if (state.merchant != null)
                            return IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.print_outlined),
                              onPressed: () {
                                final SummaryReportBloc detailReportBloc = BlocProvider.of<SummaryReportBloc>(context);

                                detailReportBloc.add(SummaryReportPrintReport(context));
                              },
                            );
                          else
                            return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                        } else
                          return IconButton(color: Colors.black38, icon: Icon(Icons.print_outlined), onPressed: () {});
                      }),
                    ]);
                  } else {
                    return Text('');
                  }
                })),
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
                  child: BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                    if (state is SummaryReportDataReady) {
                      return Container(
                        child: ListView(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 20.0),
                              title: Text('**Datos del Comercio**'),
                              subtitle: Text('${state.merchant.nameL1}\n${state.merchant.nameL2}\n${state.merchant.city}\n${"RIF:"+state.merchant.taxID}'),
                              isThreeLine: true,
                            ),
                            ListTile(
                              title:Column(
                                children: <Widget>[
                                  Divider(thickness:3,color: Colors.black54),
                                  fileReportsubHead("**Parámetros Generales**","",325),
                                  fileReportBody("Cód Comercio",":",state.merchant.mid.toString()),
                                  fileReportBody("Número de Serie",":",state.merchant.maxTip.toString()),
                                  fileReportBody("N° de Terminal",":",state.merchant.tid),
                                  fileReportBody("Cód. Moneda",":",state.merchant.currencyCode.toString()),
                                  fileReportBody("Simbolo Moneda",":",state.merchant.currencySymbol.toString()),
                                  fileReportBody("Cód. Adquiriente",":",state.merchant.acquirerCode.toString()),
                                  fileReportBody("Tlf. Primario",":",'N/A'),
                                  fileReportBody("Tlf. Secundario",":",'N/A'),
                                  fileReportBody("TPDU",":",state.comm.tpdu),
                                  fileReportBody("NII",":",state.comm.nii),
                                  fileReportBody("Tipo Soft",":",'Normal'),
                                  fileReportBody("Cash Back",":",state.acquirer.cashback==true ? "Si":"No"),
                                  fileReportBody("Cuotas",":",state.terminal.installments==true ? "Si":"No"),
                                  fileReportBody("Devolución",":",state.acquirer==true ? "Si":"No"),
                                  fileReportBody("Provimilla",":",state.acquirer.provimillas==true ? "Si":"No"),
                                  fileReportBody("Cheque",":",state.acquirer.cheque==true ? "Si":"No"),
                                  fileReportBody("Check In/Out",":",state.acquirer.checkIncheckOut==true ? "Si":"No"),
                                  fileReportBody("VTA. Fuera Línea",":",state.acquirer.saleOffline==true ? "Si":"No"),
                                  fileReportBody("CVV2",":",state.acquirer.cvv2==true ? "Si":"No"),
                                  fileReportBody("4 Ult. Dígitos",":",state.acquirer.last4Digits==true ? "Si":"No"),
                                  fileReportBody("Clave Anulación",":",state.terminal.passwordRefund==true ? "Si":"No"),
                                  fileReportBody("Clave Cierre",":",state.terminal.passwordBatch==true ? "Si":"No"),
                                  fileReportBody("Clave Devolución",":",state.terminal.passwordRefund==true ? "Si":"No"),
                                  fileReportBody("Mask Card",":",state.terminal.maskPan==true ? "Si":"No"),
                                  fileReportBody("Pre-Impresión",":",state.acquirer.prePrint==true ? "Si":"No"),
                                  fileReportBody("Amount Confirm",":",state.terminal.amountConfirmation==true ? "Si":"No"),
                                  fileReportBody("Clave Supervisor",":",state.terminal.techPassword.toString()),
                                  fileReportBody("% Propina:",":",'N/A'),
                                  fileReportBody("Temp RPTA",":",state.terminal.timeoutPrompt.toString()),
                                  fileReportBody("Temp ENT Datos",":",state.terminal.timeoutPrompt.toString()),
                                  fileReportBody("Fecha y Hora",":",new DateFormat("ddMMyyyyhhmmss").format(DateTime.now())),
                                  fileReportBody("Cód País Term...",":",state.merchant.countryCode.toString()),
                                  fileReportBody("Fallback",":",state.emv.fallback==true ? "Si":"No"),
                                  fileReportBody("Forzar Online",":",state.emv.forceOnline==true ? "Si":"No"),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                ),

                                ],
                              )
                            ),
                          ],
                        ),
                      );
                    } else
                      return SplashScreen();
                  }))
            ])),
          ],
        ),
      ),
    );
  }

  Widget fileReportBody (txt1, txt2, txt3){

    return
 Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Spacer(flex: 2),
    SizedBox(
      width: 127,
      child:  Text(txt1,
          textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.normal)
          ),
    ),
          Spacer(flex: 20),
          SizedBox(
            width: 60,
            child: Text((txt2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFeatures: [FontFeature.proportionalFigures()],
                )
            ),
          ),
        // Spacer(flex: 1),
          SizedBox(
            width: 140,
            child: Text(txt3,
                textAlign: TextAlign.left,
              ),

          ),
        ],
      );



  }

  Widget fileReportsubHead (String txt1, String txt2, double iwidth){
    return
      Row(
        children: [
          Spacer(flex: 2),
          SizedBox(
            width: 325,
            child:  Text(txt1,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal)
            ),
          ),
        ],
      );
  }

  Widget fileReportFooter (String txt1, String txt2,  double iwidth  ){
    return
      Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Spacer(flex: 2),
          SizedBox(
            width: iwidth,
            child:  Text(txt1,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal)
            ),
          ),
          Spacer(flex: 20),
          SizedBox(
            width: 202.5,
            child: Text((txt2),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFeatures: [FontFeature.proportionalFigures()],
                )
            ),
          ),
        ],
      );
  }


}
