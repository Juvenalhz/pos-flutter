import 'package:pay/models/acquirer.dart';
import 'package:pay/utils/database.dart';

class AcquirerRepository {
  final appdb = DatabaseHelper.instance;

  Future getacquirer(int id) => appdb.queryById('acquirer', id);

  Future createacquirer(Acquirer acquirer) => appdb.insert('acquirer', acquirer.toMap());

  Future updateacquirer(Acquirer acquirer) => appdb.update('acquirer', acquirer.id, acquirer.toMap());

  Future deleteacquirer(int id) => appdb.delete('acquirer', id);

  Future getCountacquirers() => appdb.queryRowCount('acquirer');

  Future<List<Map<String, dynamic>>> getAllacquirers() async => await appdb.queryAllRows('acquirer');
}
