import 'package:pay/models/trans.dart';
import 'package:pay/utils/database.dart';

class TransRepository {
  final appdb = DatabaseHelper.instance;

  Future getAllTrans({String where}) => appdb.queryAllRows('trans', where: where);

  Future getTrans(int id) => appdb.queryById('trans', id);

  Future createTrans(Trans trans) async => appdb.insert('trans', await trans.toDBMap());

  Future updateTrans(Trans trans) async => appdb.update('trans', trans.id, await trans.toDBMap());

  Future deleteTrans(int id) => appdb.delete('trans', id);

  Future getCountTrans() => appdb.queryRowCount('trans', where: 'reverse=0');

  Future getCountReversal() => appdb.queryRowCount('trans', where: 'reverse=1');

  Future getTransReversal() => appdb.queryByField('trans', 'reverse', '1');

  Future getMaxId() => appdb.queryMaxId('trans');

  Future getBatchTotal() => appdb.querySumColumnArguments('trans', 'total', where: 'reverse=0 and voided=0');

  Future getTotalsData() => appdb.queryRow(
      'select count(a.id) as count, sum(a.total) as total, a.issuer as issuer, a.bin as bin, b.brand as brand, a.acquirer as acquirer from trans as a, bin as b ' +
          'where a.bin = b.id and a.voided = 0 and a.type<>\'Anulación\' and a.reverse = 0 group by b.brand , a.issuer order by a.issuer');
}
