import 'package:pay/models/aid.dart';
import 'package:pay/utils/database.dart';

class AidRepository {
  final appdb = DatabaseHelper.instance;

  Future getAid(int id) => appdb.queryById('aid', id);

  Future getAids({String query}) => appdb.queryAllRows('aid');

  Future createAid(AID aid) => appdb.insert('aid', aid.toMap());

  Future updateAid(AID aid) => appdb.update('aid', aid.id, aid.toMap());

  Future deleteAid(AID aid) => appdb.deleteRows('aid', where: 'aid = ? ', whereArgs: [aid.aid]);

  Future getCountAids() => appdb.queryRowCount('aid');

  Future<bool> existAid(AID aid) async {
    String where = "aid = '${aid.aid}'";
    int i = await appdb.queryRowCountArguments('aid', where: where);
    if (i == 0)
      return false;
    else
      return true;
  }
}
