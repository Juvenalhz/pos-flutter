import 'package:pay/models/merchant.dart';
import 'package:pay/utils/database.dart';

class MerchantRepository {
  final appdb = DatabaseHelper.instance;

  Future getMerchants({String query}) => appdb.queryAllRows('merchant');

  Future getMerchant(int id) => appdb.queryById('merchant', id);

  Future createMerchant(Merchant merchant) => appdb.insert('merchant', merchant.toMap());

  Future updateMerchant(Merchant merchant) => appdb.update('merchant', merchant.id, merchant.toMap());

  Future deleteMerchant(int id) => appdb.delete('merchant', id);

  Future getCountMerchants() => appdb.queryRowCount('merchant');
}