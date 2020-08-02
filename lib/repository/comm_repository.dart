import 'package:pay/models/comm.dart';
import 'package:pay/utils/database.dart';

class CommRepository {
  final appdb = DatabaseHelper.instance;

  Future getComm(int id) => appdb.queryById('comm', id);

  Future createComm(Comm comm) => appdb.insert('comm', comm.toMap());

  Future updateComm(Comm comm) => appdb.update('comm', comm.id, comm.toMap());

  Future deleteComm(int id) => appdb.delete('comm', id);

  Future getCountComms() => appdb.queryRowCount('comm');
}
