import 'package:pay/models/trans.dart';
import 'package:pay/utils/database.dart';

class TransRepository {
  final appdb = DatabaseHelper.instance;

  Future getAllTrans({String query}) => appdb.queryAllRows('trans');

  Future getTrans(int id) => appdb.queryById('trans', id);

  Future createTrans(Trans trans) async => appdb.insert('trans', await trans.toDBMap());
  
  Future updateTrans(Trans trans) async => appdb.update('trans', trans.id, await trans.toDBMap());

  Future deleteTrans(int id) => appdb.delete('trans', id);

  Future getCountTrans() => appdb.queryRowCount('trans');

  Future getCountReversal() => appdb.queryRowCount('trans', where: 'reverse=1');

  Future getTransReversal() => appdb.queryByField('trans', 'reverse', '1');

  Future getMaxId() => appdb.queryMaxId('trans');
}
