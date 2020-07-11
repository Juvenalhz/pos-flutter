import 'package:pay/models/merchant.dart';
import 'database.dart';

class Init {
  final appdb = DatabaseHelper.instance;
  String Name = '';

  void _insertMerchant() async {
    // row to insert
    Map<String, dynamic> row = {'name': 'Merchant ABC', 'address': '1 main st'};
    final id = await appdb.insert('merchant', row);
    print('inserted row id: $id');
  }

  Future<String> _getName() async {
    Map<String, dynamic> merchant = await appdb.queryById('merchant', 1);

    if (const String.fromEnvironment('dev') != null) {
      if (Merchant.fromMap(merchant).name == null) {
        _insertMerchant();
        merchant = await appdb.queryById('merchant', 1);
      }
    }
    return Merchant.fromMap(merchant).name;
  }

   _registerServices() async {
    print("starting registering services");
    //await Future.delayed(Duration(seconds: 1));
    print("finished registering services");
  }

  Future<void> _loadSettings() async {
    print("starting loading settings");

    Name = await _getName();

    print("finished loading settings");
  }

  Future<void> initialize() async {
    await _registerServices();
    await _loadSettings();
  }
}

