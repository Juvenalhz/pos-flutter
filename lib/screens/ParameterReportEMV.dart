import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pay/bloc/summaryReportBloc.dart';
import 'package:pay/models/aid.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/pubkey.dart';
import 'package:pay/screens/components/item_tile_two_column.dart';
import 'package:pay/screens/splash.dart';
import 'package:pay/utils/serialNumber.dart';

class ParameterReportEMV extends StatelessWidget {
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
                  if (state is ParameterReportDataReady) {
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
                              'Reporte',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              'Parámetros EMV',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<SummaryReportBloc, SummaryReportState>(builder: (context, state) {
                        if (state is ParameterReportDataReady) {
                          if (state.merchant != null)
                            return IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.print_outlined),
                              onPressed: () {
                                final SummaryReportBloc detailReportBloc = BlocProvider.of<SummaryReportBloc>(context);

                                detailReportBloc.add(ParameterReportPrintReport(context));
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
                        if (state is ParameterReportDataReady) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: ListView(
                                physics: new ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                controller: ScrollController(),
                                children: [
                                  ...fileMerchantData(state.merchant),
                                  fileReportsubHead("**DATOS GENERALES**","",325),
                                  ...fileGralData(state.emv),
                                  fileReportsubHead("**TABLA AIDs***", "", 325),
                                  ...fileAIDs(state.aids),
                                  fileReportsubHead("**TABLA LLAVES**", "", 325),
                                  ...filepubKeys(state.pubKey)
                                ]),
                          );
                        } else
                          return SplashScreen();
                      })),
                ])),
          ],
        ),
      ),
    );
  }

  Widget fileReportHead(txt1, txt2, txt3,double w1,double w2,double w3) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(flex: 10),
        SizedBox(
          width: w1,
          child: Text(txt1, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal)),
        ),
        Spacer(flex: 20),
        SizedBox(
          width: w2,
          child: Text((txt2),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFeatures: [FontFeature.proportionalFigures()],
              )),
        ),
        Spacer(flex: 18),
        SizedBox(
          width: w3,
          child: Text(
            txt3,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget fileReportsubHead(String txt1, String txt2, double iwidth) {
    return Row(
      children: [
        Spacer(flex: 2),
        SizedBox(
          width: 325,
          child: Text(
            txt1,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  Widget fileReportBody(txt1, txt2, txt3) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(flex: 10),
        SizedBox(
          width: 127,
          child: Text(txt1, textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              )
          ),
        ),
        Spacer(flex: 20),
        SizedBox(
          width: 23,
          child: Text((txt2),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFeatures: [FontFeature.proportionalFigures()],
              )),
        ),
        Spacer(flex: 18),
        SizedBox(
          width: 170,

          child: Text(
            txt3,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget fileReportFooter(String txt1, String txt2, double iwidth) {
    return Row(
      children: [
        Spacer(flex: 2),
        SizedBox(
          width: iwidth,
          child: Text(txt1, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.normal)),
        ),
        Spacer(flex: 20),
        SizedBox(
          width: 202.5,
          child: Text((txt2),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFeatures: [FontFeature.proportionalFigures()],
              )),
        ),
      ],
    );
  }

  List<Widget> fileMerchantData(Merchant mapMerchant) {
    List<Widget> merchantData = [];
    final sn =  SerialNumber.serialNumber;

    merchantData.add(fileReportHead("", mapMerchant.nameL1, "",20,320,20));
    merchantData.add(fileReportHead("", mapMerchant.nameL2, "",20,320,20));
    merchantData.add(fileReportHead("", mapMerchant.city, "",20,320,20));
    merchantData.add(fileReportHead("RIF : "+mapMerchant.taxID.toString(),"", "Afiliado: "+ mapMerchant.mid.trim(),165,5,175));
    merchantData.add(fileReportHead("", "SN/POS: "+     sn.toString(), "",20,320,20));

    merchantData.add(Divider(
      thickness: 3,
      indent: 4.0,
      endIndent: 4.0,
      color: Colors.black54,
    ));
    return merchantData;
  }
  List<Widget> fileGralData(Emv mapEmv) {
    List<Widget> emvData = [];
    emvData.add(fileReportBody("Tipo Terminal", ":", mapEmv.terminalType.toString()));
    emvData.add(fileReportBody("Ter Capabilities", ":", mapEmv.terminalCapabilities.toString()));
    emvData.add(fileReportBody("Fallback", ":", mapEmv.fallback==true ? "Si":"No"));
    emvData.add(fileReportBody("Forzar Online", ":", mapEmv.forceOnline==true ? "Si":"No"));
    emvData.add(Divider(
      indent: 4.0,
      endIndent: 4.0,
      color: Colors.black54,
    ));
    return emvData;
  }
  List<Widget> fileAIDs(List<Map<String, dynamic>> mapAIDs) {
    List<Widget> aids = [];
    int AidsLen = mapAIDs.length;
    for (int i = 0; i <= AidsLen - 1; i++) {
      aids.add(fileReportBody("RID+PIX", ":", mapAIDs[i]['aid'].toString()));
      aids.add(fileReportBody("Limite Piso", ":", mapAIDs[i]['floorLimit'].toString()));
      aids.add(fileReportBody("Versión", ":", mapAIDs[i]['version'].toString()));
      aids.add(fileReportBody("TAC Denial", ":", mapAIDs[i]['tacDenial'].toString()));
      aids.add(fileReportBody("TAC Online", ":", mapAIDs[i]['tacOnline'].toString()));
      aids.add(fileReportBody("TAC Default", ":", mapAIDs[i]['tacDefault'].toString()));
      aids.add(fileReportBody("Threshold Value", ":", mapAIDs[i]['thresholdAmount'].toString()));
      aids.add(fileReportBody("Target Percent", ":", mapAIDs[i]['targetPercentage'].toString()));
      aids.add(fileReportBody("Max Tar Percent", ":", mapAIDs[i]['maxTargetPercentage'].toString()));
      aids.add(fileReportBody("TDOL", ":", mapAIDs[i]['tdol'].toString()));
      aids.add(fileReportBody("DDOL", ":", mapAIDs[i]['ddol'].toString()));
      aids.add(Divider(thickness:0.50,color: Colors.black54, indent: 5,endIndent: 5,),);
    }
    return aids;
  }

  List<Widget> filepubKeys(List<Map<String, dynamic>> mapKEYs) {
    List<Widget> keys = [];

    int keysLen = mapKEYs.length;
    for (int i = 0; i <= keysLen - 1; i++) {
      keys.add(fileReportBody("Public Key Index", ":", mapKEYs[i]['keyIndex'].toString()));
      keys.add(fileReportBody("Key Length", ":", mapKEYs[i]['length'].toString()));
      keys.add(fileReportBody("Key Exponent", ":", mapKEYs[i]['exponent'].toString()));
      keys.add(fileReportBody("RID", ":", mapKEYs[i]['rid'].toString()));
      keys.add(fileReportBody("Expiration Date", ":", mapKEYs[i]['expDate'].toString()));
      keys.add(Divider(
        indent: 4.0,
        endIndent: 4.0,
        color: Colors.black54,
      ));
    }
    return keys;
  }


}