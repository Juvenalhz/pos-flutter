import 'package:pay/models/terminal.dart';
import 'package:pay/utils/database.dart';

class TerminalRepository {
  final appdb = DatabaseHelper.instance;

  Future getTerminal(int id) => appdb.queryById('terminal', id);

  Future createTerminal(Terminal terminal) => appdb.insert('terminal', terminal.toMap());

  Future updateTerminal(Terminal terminal) => appdb.update('terminal', terminal.id, terminal.toMap());

  Future deleteTerminal(int id) => appdb.delete('terminal', id);

  Future getCountTerminals() => appdb.queryRowCount('terminal');
}
