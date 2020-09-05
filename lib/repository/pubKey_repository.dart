import 'package:pay/models/pubkey.dart';
import 'package:pay/utils/database.dart';

class PubKeyRepository {
  final appdb = DatabaseHelper.instance;

  Future getPubKey(int id) => appdb.queryById('pubKey', id);

  Future createPubKey(PubKey pubKey) => appdb.insert('pubKey', pubKey.toMap());

  Future updatePubKey(PubKey pubKey) => appdb.update('pubKey', pubKey.id, pubKey.toMap());

  Future deletePubKey(PubKey pubKey) {
    String where = "index =  '''${pubKey.index}'''" + 'and rid=' + "rid =  '''${pubKey.rid}'''";
    appdb.deleteRows('pubKey', where: where);
  }

  Future getCountPubKeys() => appdb.queryRowCount('pubKey');

  Future<bool> existPubKey(PubKey pubKey) async {
    String where = "index =  '''${pubKey.index}'''" + 'and rid=' + "rid =  '''${pubKey.rid}'''";
    int i = await appdb.queryRowCountArguments('pubKey', where: where);
    if (i == 0)
      return false;
    else
      return true;
  }
}
