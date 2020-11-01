import 'package:pay/models/trans.dart';
import 'package:pay/utils/database.dart';

class TransRepository {
  final appdb = DatabaseHelper.instance;

  Future getAllTrans({String query}) => appdb.queryAllRows('trans');

  Future getTrans(int id) => appdb.queryById('trans', id);

  Future createTrans(Trans trans) => appdb.insert('trans', trans.toDBMap());
  
  Future updateTrans(Trans trans) => appdb.update('trans', trans.id, trans.toDBMap());
  
  Future deleteTrans(int id) => appdb.delete('trans', id);

  Future getCountTrans() => appdb.queryRowCount('trans');
}
