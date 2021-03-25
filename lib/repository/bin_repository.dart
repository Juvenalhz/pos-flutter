import 'package:pay/models/bin.dart';
import 'package:pay/utils/database.dart';

class BinRepository {
  final appdb = DatabaseHelper.instance;

  Future getBin(int id) => appdb.queryById('bin', id);

  Future createBin(Bin bin) => appdb.insert('bin', bin.toMap());

  Future updateBin(Bin bin) => appdb.update('bin', bin.id, bin.toMap());

  Future deleteBin(Bin bin) => appdb.deleteRows('bin', where: 'binLow = ? and binHigh = ?', whereArgs: [bin.binLow, bin.binHigh]);

  Future getCountBins() => appdb.queryRowCount('bin');

  Future<bool> existBin(Bin bin) async {
    String where = 'binLow = ' + bin.binLow.toString() + ' and binHigh = ' + bin.binHigh.toString();
    int i = await appdb.queryRowCountArguments('bin', where: where);
    if (i == 0)
      return false;
    else
      return true;
  }

  Future<int> getBinId(String bin) async {
    String where = 'binLow <= ' + bin + ' and binHigh >= ' + bin;
    List<Map<String, dynamic>> bins = await appdb.queryAllRows('bin', where: where);

    if (bins.length >= 1) {
      return bins[0]['id'];
    } else
      return 0;
  }
}
