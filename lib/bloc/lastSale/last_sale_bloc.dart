import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/utils/communication.dart';

part 'last_sale_event.dart';
part 'last_sale_state.dart';

class LastSaleBloc extends Bloc<LastSaleEvent, LastSaleState> {
  LastSaleBloc() : super(LastSaleInitial());
  Comm comm;
  Communication connection;
  LastSaleMessage lastSale;

  @override
  Stream<LastSaleState> mapEventToState(
    LastSaleEvent event,
  ) async* {
    var isCommOffline = (const String.fromEnvironment('offlineComm') == 'true');
    var isDev = (const String.fromEnvironment('dev') == 'true');

    if (event is LastSaleInitialEvent)
      yield LastSaleInitial();
    else if (event is LastSaleConnect) {
      comm = event.comm;
      lastSale = new LastSaleMessage(comm);

      yield LastSaleConnecting(comm);

      connection = new Communication(comm.ip, comm.port, true, comm.timeout);

      if ((isDev == true) && (isCommOffline == true)) {
        this.add(LastSaleSend());
        yield LastSaleSending();
      }
      else if (await connection.connect() == true) {
        this.add(LastSaleSend());
        yield LastSaleSending();
      } else {
        yield LastSaleCommError();
      }
    }
    else if (event is LastSaleSend) {
      if ((isDev == true) && (isCommOffline == true))
        await lastSale.buildMessage();
      else
        connection.sendMessage(await lastSale.buildMessage());

      incrementStan();
      this.add(LastSaleReceive());
      yield LastSaleReceiving();
    }
    else if (event is LastSaleReceive) {
      Uint8List response;

      response = await connection.receiveMessage();
      if (response  == null){
        yield LastSaleShowMessage('Error - Timeout de comunicación');
        await new Future.delayed(const Duration(seconds: 3));
        yield LastSaleFailed('Error En Prueba De Comunicación');
      }
      else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await lastSale.parseRenponse(response);
        if (respMap[39] == '00') {
          var trans = new Trans();
          int lastTransState = int.parse(respMap[6220].substring(0, 1));
          int lastTransType = int.parse(respMap[6220].substring(1, 2));
          int lastTransDay = int.parse(respMap[6220].substring(3, 5));
          int lastTransMonth = int.parse(respMap[6220].substring(5, 7));
          int lastTransYear = 2000 + int.parse(respMap[6220].substring(7, 9));

          if (lastTransType == 5)
            trans.type = 'Venta Tarjeta Alimenticia';
          else
            trans.type = 'Compra';

          trans.total = int.parse(respMap[4]);
          trans.maskedPAN = respMap[2].substring(0, 4) + '....' + respMap[2].substring(respMap[2].length - 4);

          trans.stan = int.parse(respMap[6201]);

          trans.dateTime = DateTime(lastTransYear, lastTransMonth, lastTransDay,  int.parse(respMap[12].substring(0, 2)),
              int.parse(respMap[12].substring(2, 4)), int.parse(respMap[12].substring(4, 6)));

          trans.referenceNumber = respMap[37];
          trans.authCode = respMap[38];
          trans.respMessage = respMap[6208];

          //TODO: handle the food card balance
          // if (respMap[6216] != null)
          //   trans.foodCardBalance = respMap[6216]

          yield LastSaleCompleted(trans);

        }
        else  // error in echo test response
          yield LastSaleFailed('Error En Prueba De Comunicación');
      }
      connection.disconnect();
    }
  }
}
