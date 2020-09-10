import 'package:pay/models/emv.dart';
import 'package:pay/utils/database.dart';

class EmvRepository {
  final appdb = DatabaseHelper.instance;

  Future getEmv(int id) => appdb.queryById('emv', id);

  Future createEmv(Emv emv) => appdb.insert('emv', emv.toMap());

  Future updateEmv(Emv emv) => appdb.update('emv', emv.id, emv.toMap());

  Future deleteEmv(int id) => appdb.delete('emv', id);

  Future getCountEmvs() => appdb.queryRowCount('emv');
}
