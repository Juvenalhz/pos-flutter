import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pay/iso8583/hostMessages.dart';
import 'package:pay/models/bin.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/bin_repository.dart';
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

      if (response.isEmpty){
        yield LastSaleFailed('Sin respuesta del Host');
      }
      else if ((connection.frameSize != 0) || (isCommOffline == true)) {
        Map<int, String> respMap = await lastSale.parseRenponse(response);
        if (respMap[39] == '00') {
          var trans = new Trans();
          BinRepository binRepository = new BinRepository();
          int binId = await binRepository.getBinId(respMap[2].substring(0, 8));
          Bin bin = Bin.fromMap(await binRepository.getBin(binId));
          int lastTransState = int.parse(respMap[6220].substring(0, 1));
          int lastTransType = int.parse(respMap[6220].substring(1, 2));
          int lastTransDay = int.parse(respMap[6220].substring(3, 5));
          int lastTransMonth = int.parse(respMap[6220].substring(4, 6));
          int lastTransYear = 2000 + int.parse(respMap[6220].substring(2, 4));

          trans.type = 'Venta';

          if (lastTransState == 0)
            trans.respCode = '00';
          else if (lastTransState == 2)
            trans.respCode = '01';
          else if (lastTransState == 1) {
            trans.type = 'Anulación';
            trans.respCode = '00';
          }

          trans.bin = binId;
          trans.binType = bin.cardType;

          trans.total = int.parse(respMap[4]);
          trans.maskedPAN = respMap[2].substring(0, 6) + '....' + respMap[2].substring(respMap[2].length - 4);

          trans.id = int.parse(respMap[6201]);
          trans.stan = int.parse(respMap[6201]);

          if (respMap[62.02] != null)
            trans.batchNum = int.parse(respMap[62.02]);

          trans.dateTime = DateTime(lastTransYear, lastTransMonth, lastTransDay,  int.parse(respMap[12].substring(0, 2)),
              int.parse(respMap[12].substring(2, 4)), int.parse(respMap[12].substring(4, 6)));

          trans.referenceNumber = respMap[37];
          trans.authCode = respMap[38];
          trans.respMessage = respMap[6208];

          if (respMap[6216] != null)
             trans.foodBalance = int.parse(respMap[6216]);

          yield LastSaleCompleted(trans, bin.brand);

        }
        else  // error in echo test response
          yield LastSaleFailed('Error En Prueba De Comunicación');
      }
      connection.disconnect();
    }
  }
}
