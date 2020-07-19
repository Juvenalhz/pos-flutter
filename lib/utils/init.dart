import 'package:pay/models/merchant.dart';
import 'database.dart';

class Init {
  final appdb = DatabaseHelper.instance;
  String Name = '';

  void _insertMerchant() async {
    // row to insert
    Map<String, dynamic> row = {'id': '1', 'Name': 'Merchant ABC', 'Address': '1 main st'};
    final id = await appdb.insert('merchant', row);
    print('inserted row id: $id');
  }

  Future<void> initialize() async {
    await _insertMerchant();
  }
}

