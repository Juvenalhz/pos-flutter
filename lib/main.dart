import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/screens/mainScreen.dart';
import 'package:pay/utils/database.dart';
import 'package:pay/utils/init.dart';
import 'bloc/merchant_bloc.dart';
import 'package:pay/iso8583/8583specs.dart';
import 'package:pay/iso8583/8583.dart';
import 'dart:typed_data';

void main() => runApp(InitializationApp());

class InitializationApp extends StatelessWidget {
  bool isDev = (const String.fromEnvironment('dev') != null);
  Future<void> _initFuture = Init().initialize();
  MerchantRepository merchantRepository = new MerchantRepository();
  final appdb = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    Uint8List isoMsg = new Uint8List(2000);
    Uint8List data;

    Iso8583 isoPacket = Iso8583(null, ISOSPEC.ISO_BCD);

    isoPacket.setMID(0200);

    isoPacket.fieldData(3, '3000');
    isoPacket.fieldData(4, '123');
    isoPacket.fieldData(7, '1030050505');
    isoPacket.fieldData(11, '333');
    isoPacket.fieldData(12, '505');
    isoPacket.fieldData(13, '1030');
    isoPacket.fieldData(15, '1030');
    isoPacket.fieldData(22, '51');
    isoPacket.fieldData(23, '1');
    isoPacket.fieldData(24, '111');
    isoPacket.fieldData(25, '0');
    isoPacket.fieldData(32, '006432');
    isoPacket.fieldData(35, '5548975439889554=9886954728965478965834');
    isoPacket.fieldData(41, '11111111');
    isoPacket.fieldData(42, '222222222222222');
    isoPacket.fieldData(48, '   124587896');

    isoPacket.fieldData(49, '840');
    isoPacket.fieldData(55,
        '5F2A020937820239008407A0000000041010950500000080009A031909029C01009F02060000000002009F03060000000000005F3401009F090200029F10120110604001220000365000000000000000FF9F1A0208629F1E0831323336313138339F26085E0F0E80C87EA2A89F2701409F3303E0F0C89F34031E03009F3501229F3602007A9F370470792F499F530152');
    isoPacket.fieldData(59, '511101512341101');
    isoPacket.fieldData(60, '000011');

    print("\n");

    data = isoPacket.buildIso();

    isoPacket.printMessage();

    return MaterialApp(
      debugShowCheckedModeBanner: isDev,
      title: 'Initialization',
      home: Scaffold(
        body: BlocProvider<MerchantBloc>(
          create: (context) => MerchantBloc(merchantRepository: merchantRepository),
          child: MainScreen() ),
        ),
    );
  }
}
