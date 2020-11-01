import 'database.dart';

class testConfig {
  final appdb = DatabaseHelper.instance;

  Future<void> _CreateMerchant() async {
    // row to insert
    Map<String, dynamic> testMerchant = {
      'id': 1,
      'NameL1': 'Mi Tienda de Pruebas 1',
      'NameL2': 'Calle principal #1',
      'City': 'cuidad de la tienda',
      'TID': '01',
      'MID': '123456789012',
      'CurrencyCode': 928,
      'CurrencySymbol': 'BsS',
      'CountryCode': 862,
      'Password': '000000',
      'Header': 'Este es el encabezado del recibo para usar en la impresion',
      'Amount_MaxDigtis': 12,
      'Amount_DecimalPosition': 2,
      'BatchNumber': 1,
      'MaxTip': 10,
      'TaxID': '999888777',
      'Logo': '',
      'AcquirerCode': '00',
    };

    await appdb.deleteAll('merchant');
    final id = await appdb.insert('merchant', testMerchant);
    print('inserted row id: $id');
  }

  void _CreateTerminal() async {
    // row to insert
    Map<String, dynamic> testTerminal = {
      'id': 1,
      'password': '000000',
      'techPassword': '000000',
      'idTerminal': '00000000',
      'kin': 1,
      'minPinDigits': 4,
      'maxPinDigits': 12,
      'timeoutPrompt': 60,
      'maxTipPercentage': 10,
      'keyIndex': 2,
      'industry': 'Retail',
      'print': 1,
      'cashback': 0,
      'installments': 0,
      'refund': 0,
      'last4Digits': 1,
      'passwordVoid': 1,
      'passwordBatch': 1,
      'passwordRefund': 1,
      'maskPan': 1,
      'amountConfirmation': 1,
    };

    await appdb.deleteAll('terminal');
    final id = await appdb.insert('terminal', testTerminal);
    print('inserted row id: $id');
  }

  void _CreateComm() async {
    // row to insert
    Map<String, dynamic> testComm = {
      'id': 1,
      'Name': 'Platco',
      'tpdu': '0000900000',
      'nii': '111',
      'timeout': 60,
      'ip': '192.168.11.209',
      'port': 9000,
      'headerLength': 2,
    };

    await appdb.deleteAll('comm');
    final id = await appdb.insert('comm', testComm);
    print('inserted row id: $id');
  }

  void _CreateEmv() async {
    // row to insert
    Map<String, dynamic> testEmv = {
      'id': 1,
      'terminalType': '22',
      'terminalCapabilities': 'E0F8C8',
      'addTermCapabilities': 'F0000F0F001',
      'fallback': 1,
      'forceOnline': 1,
      'CurrencyCode': 0,
      'CountryCode': 0,
    };

    await appdb.deleteAll('emv');
    final id = await appdb.insert('emv', testEmv);
    print('inserted row id: $id');
  }

  void _CreateAcquirer() async {
    // row to insert
    Map<String, dynamic> testAcquirer = {
      'id': 1,
      'name': 'Platco',
      'rif': '222222',
      'industryType': 1,
      'cashback': 1,
      'installmets': 1,
      'refund': 1,
      'provimillas': 1,
      'cheque': 1,
      'checkIncheckOut': 1,
      'saleOffline': 1,
      'cvv2': 1,
      'last4Digits': 1,
      'passwordVoid': 1,
      'passwordSettlement': 1,
      'passwordRefund': 1,
      'maskPan': 1,
      'prePrint': 1,
      'manualEntry': 1,
    };

    await appdb.deleteAll('acquirer');
    final id = await appdb.insert('acquirer', testAcquirer);
    print('inserted row id: $id');
  }

  Future<void> createTestConfiguration() async {
    await _CreateMerchant();
    await _CreateTerminal();
    await _CreateComm();
    await _CreateEmv();
    await _CreateAcquirer();

    await appdb.deleteAll('bin');
  }
}
