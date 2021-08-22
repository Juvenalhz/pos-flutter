import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/models/acquirer.dart';
import 'package:pay/models/comm.dart';
import 'package:pay/models/merchant.dart';
import 'package:pay/models/terminal.dart';
import 'package:pay/models/emv.dart';
import 'package:pay/models/trans.dart';
import 'package:pay/repository/acquirer_repository.dart';
import 'package:pay/repository/aid_repository.dart';
import 'package:pay/repository/comm_repository.dart';
import 'package:pay/repository/emv_repository.dart';
import 'package:pay/repository/merchant_repository.dart';
import 'package:pay/repository/pubKey_repository.dart';
import 'package:pay/repository/terminal_repository.dart';
import 'package:pay/repository/trans_repository.dart';
import 'package:pay/utils/receipt.dart';
import 'package:pay/utils/reports.dart';
import 'package:pay/utils/serialNumber.dart';

part 'summary_report_event.dart';
part 'summary_report_state.dart';

class SummaryReportBloc extends Bloc<SummaryReportEvent, SummaryReportState> {
  SummaryReportBloc() : super(SummaryReportInitial());

  @override
  Stream<SummaryReportState> mapEventToState(
    SummaryReportEvent event,
  ) async* {
    if (event is SummaryReportGetData) {
      MerchantRepository merchantRepository = new MerchantRepository();
      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      TerminalRepository terminalRepository = new TerminalRepository();
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
      CommRepository commRepository = new CommRepository();
      Comm comm = Comm.fromMap(await commRepository.getComm(1));
      AcquirerRepository acquirerRepository = new AcquirerRepository();
      Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));

      EmvRepository emvRepository = new EmvRepository();
      Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
      String sn = await SerialNumber.serialNumber;

      yield SummaryReportDataReady(merchant, terminal, comm, acquirer, emv, sn);
    } else if (event is SummaryReportPrintReport) {
      Reports report = new Reports();

      report.printSummaryReport();
    } else if (event is ParameterReportGetData) {
      MerchantRepository merchantRepository = new MerchantRepository();
      Merchant merchant = Merchant.fromMap(await merchantRepository.getMerchant(1));
      TerminalRepository terminalRepository = new TerminalRepository();
      Terminal terminal = Terminal.fromMap(await terminalRepository.getTerminal(1));
      CommRepository commRepository = new CommRepository();
      Comm comm = Comm.fromMap(await commRepository.getComm(1));
      AcquirerRepository acquirerRepository = new AcquirerRepository();
      Acquirer acquirer = Acquirer.fromMap(await acquirerRepository.getacquirer(merchant.acquirerCode));
      EmvRepository emvRepository = new EmvRepository();
      Emv emv = Emv.fromMap(await emvRepository.getEmv(1));
      PubKeyRepository pubKeyRepository = new PubKeyRepository();
      List<Map<String, dynamic>> pubKey = await pubKeyRepository.getPubKeys();
      AidRepository aidRepository = new AidRepository();
      List<Map<String, dynamic>> aids = await aidRepository.getAids();

      yield ParameterReportDataReady(merchant, terminal, comm, acquirer, emv, pubKey, aids);
    } else if (event is ParameterReportPrintReport) {
      Reports report = new Reports();

      report.printParameterReport();
    }
  }
}
