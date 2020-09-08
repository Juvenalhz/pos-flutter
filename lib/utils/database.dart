import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "test23db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  void _tableAlter(Database db, String table, String column, String type) async {
    try {
      if (type.compareTo('text') == 0)
        await db.execute('alter table $table add column $column $type');
      else
        await db.execute('''alter table $table add column $column $type DEFAULT '0' ''');
    } catch (e) {}
  }

  void _CreateMerchantTable(Database db) async {
    await db.execute('''
          CREATE TABLE merchant (
          id integer PRIMARY KEY AUTOINCREMENT,
          NameL1 TEXT DEFAULT '')
          ''');
    await _UpgradeMerchantTable(db);
  }

  void _UpgradeMerchantTable(Database db) async {
    _tableAlter(db, 'merchant', 'NameL2', 'text');
    _tableAlter(db, 'merchant', 'TID', 'text');
    _tableAlter(db, 'merchant', 'MID', 'text');
    _tableAlter(db, 'merchant', 'CurrencyCode', 'integer');
    _tableAlter(db, 'merchant', 'CountryCode', 'integer');
    _tableAlter(db, 'merchant', 'CurrencySymbol', 'text');
    _tableAlter(db, 'merchant', 'Password', 'text');
    _tableAlter(db, 'merchant', 'Header', 'text');
    _tableAlter(db, 'merchant', 'Amount_MaxDigtis', 'integer');
    _tableAlter(db, 'merchant', 'Amount_DecimalPosition', 'integer');
    _tableAlter(db, 'merchant', 'BatchNumber', 'integer');
    _tableAlter(db, 'merchant', 'MaxTip', 'integer');
    _tableAlter(db, 'merchant', 'City', 'text');
    _tableAlter(db, 'merchant', 'TaxID', 'text');
    _tableAlter(db, 'merchant', 'Logo', 'text');
    _tableAlter(db, 'merchant', 'AcquirerCode', 'text');
  }

  void _CreateTerminalTable(Database db) async {
    await db.execute('''
          CREATE TABLE terminal (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradeTerminalTable(db);
  }

  void _UpgradeTerminalTable(Database db) async {
    _tableAlter(db, 'terminal', 'password', 'text');
    _tableAlter(db, 'terminal', 'techPassword', 'text');
    _tableAlter(db, 'terminal', 'idTerminal', 'text');
    _tableAlter(db, 'terminal', 'kin', 'integer');
    _tableAlter(db, 'terminal', 'minPinDigits', 'integer');
    _tableAlter(db, 'terminal', 'maxPinDigits', 'integer');
    _tableAlter(db, 'terminal', 'timeoutPrompt', 'integer');
    _tableAlter(db, 'terminal', 'maxTipPercentage', 'integer');
    _tableAlter(db, 'terminal', 'keyIndex', 'integer');
    _tableAlter(db, 'terminal', 'industry', 'text');
    _tableAlter(db, 'terminal', 'print', 'text');
    _tableAlter(db, 'terminal', 'cashback', 'integer');
    _tableAlter(db, 'terminal', 'installments', 'integer');
    _tableAlter(db, 'terminal', 'refund', 'integer');
    _tableAlter(db, 'terminal', 'last4Digits', 'integer');
    _tableAlter(db, 'terminal', 'passwordVoid', 'integer');
    _tableAlter(db, 'terminal', 'passwordBatch', 'integer');
    _tableAlter(db, 'terminal', 'passwordRefund', 'integer');
    _tableAlter(db, 'terminal', 'maskPan', 'integer');
    _tableAlter(db, 'terminal', 'amountConfirmation', 'integer');
  }

  void _CreateCommTable(Database db) async {
    await db.execute('''
          CREATE TABLE comm (
          id integer PRIMARY KEY AUTOINCREMENT,
          Name TEXT DEFAULT '')
          ''');

    await _UpgradeCommTable(db);
  }

  void _UpgradeCommTable(Database db) async {
    _tableAlter(db, 'comm', 'tpdu', 'text');
    _tableAlter(db, 'comm', 'nii', 'text');
    _tableAlter(db, 'comm', 'timout', 'integer');
    _tableAlter(db, 'comm', 'ip', 'text');
    _tableAlter(db, 'comm', 'port', 'integer');
    _tableAlter(db, 'comm', 'headerLength', 'integer');
  }

  void _CreateEmvTable(Database db) async {
    await db.execute('''
          CREATE TABLE emv (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradeEmvTable(db);
  }

  void _UpgradeEmvTable(Database db) async {
    _tableAlter(db, 'emv', 'terminalType', 'text');
    _tableAlter(db, 'emv', 'terminalCapabilities', 'text');
    _tableAlter(db, 'emv', 'addTermCapabilities', 'text');
    _tableAlter(db, 'emv', 'fallback', 'integer');
    _tableAlter(db, 'emv', 'forceOnline', 'integer');
  }

  void _CreateCountersTable(Database db) async {
    await db.execute('''
          CREATE TABLE counters (
          id integer PRIMARY KEY,
          stan integer )
          ''');
  }

  void _UpgradeCountersTable(Database db) async {}

  void _CreateAcquirerTable(Database db) async {
    await db.execute('''
          CREATE TABLE acquirer (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradeAcquirerTable(db);
  }

  void _UpgradeAcquirerTable(Database db) async {
    _tableAlter(db, 'acquirer', 'name', 'text');
    _tableAlter(db, 'acquirer', 'rif', 'text');
    _tableAlter(db, 'acquirer', 'industryType', 'integer');
    _tableAlter(db, 'acquirer', 'cashback', 'integer');
    _tableAlter(db, 'acquirer', 'installmets', 'integer');
    _tableAlter(db, 'acquirer', 'refund', 'integer');
    _tableAlter(db, 'acquirer', 'provimillas', 'integer');
    _tableAlter(db, 'acquirer', 'cheque', 'integer');
    _tableAlter(db, 'acquirer', 'checkIncheckOut', 'integer');
    _tableAlter(db, 'acquirer', 'saleOffline', 'integer');
    _tableAlter(db, 'acquirer', 'cvv2', 'integer');
    _tableAlter(db, 'acquirer', 'last4Digits', 'integer');
    _tableAlter(db, 'acquirer', 'passwordVoid', 'integer');
    _tableAlter(db, 'acquirer', 'passwordSettlement', 'integer');
    _tableAlter(db, 'acquirer', 'maskPan', 'integer');
    _tableAlter(db, 'acquirer', 'prePrint', 'integer');
    _tableAlter(db, 'acquirer', 'manualEntry', 'integer');
  }

  void _CreateBinTable(Database db) async {
    await db.execute('''
          CREATE TABLE bin (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradeBinTable(db);
  }

  void _UpgradeBinTable(Database db) async {
    _tableAlter(db, 'bin', 'type', 'text');
    _tableAlter(db, 'bin', 'binLow', 'integer');
    _tableAlter(db, 'bin', 'binHigh', 'integer');
    _tableAlter(db, 'bin', 'cardType', 'integer');
    _tableAlter(db, 'bin', 'brand', 'text');
    _tableAlter(db, 'bin', 'cashback', 'integer');
    _tableAlter(db, 'bin', 'pin', 'integer');
    _tableAlter(db, 'bin', 'manualEntry', 'integer');
    _tableAlter(db, 'bin', 'fallback', 'integer');
  }

  void _CreateAidTable(Database db) async {
    await db.execute('''
          CREATE TABLE aid (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradeAidTable(db);
  }

  void _UpgradeAidTable(Database db) async {
    _tableAlter(db, 'aid', 'aid', 'text');
    _tableAlter(db, 'aid', 'floorLimit', 'integer');
    _tableAlter(db, 'aid', 'version', 'integer');
    _tableAlter(db, 'aid', 'tacDenial', 'text');
    _tableAlter(db, 'aid', 'tacOnline', 'text');
    _tableAlter(db, 'aid', 'tacDefault', 'text');
    _tableAlter(db, 'aid', 'exactMatch', 'integer');
    _tableAlter(db, 'aid', 'thresholdAmount', 'integer');
    _tableAlter(db, 'aid', 'targetPercentage', 'integer');
    _tableAlter(db, 'aid', 'maxTargetPercentage', 'integer');
    _tableAlter(db, 'aid', 'tdol', 'text');
    _tableAlter(db, 'aid', 'ddol', 'text');
  }

  void _CreatePubKeyTable(Database db) async {
    await db.execute('''
          CREATE TABLE pubkey (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    await _UpgradePubKeyTable(db);
  }

  void _UpgradePubKeyTable(Database db) async {
    _tableAlter(db, 'pubkey', 'keyIndex', 'integer');
    _tableAlter(db, 'pubkey', 'rid', 'text');
    _tableAlter(db, 'pubkey', 'exponent', 'text');
    _tableAlter(db, 'pubkey', 'expDate', 'text');
    _tableAlter(db, 'pubkey', 'length', 'integer');
    _tableAlter(db, 'pubkey', 'modulus', 'text');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    _CreateMerchantTable(db);
    _CreateTerminalTable(db);
    _CreateCommTable(db);
    _CreateEmvTable(db);
    _CreateCountersTable(db);
    _CreateAcquirerTable(db);
    _CreateBinTable(db);
    _CreateAidTable(db);
    _CreatePubKeyTable(db);

    Map<String, dynamic> initialCounter = {
      'id': 1,
      'stan': 1,
    };

    await db.insert('counters', initialCounter);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _UpgradeMerchantTable(db);
    _UpgradeTerminalTable(db);
    _UpgradeCommTable(db);
    _UpgradeEmvTable(db);
    _UpgradeCountersTable(db);
    _UpgradeAcquirerTable(db);
    _UpgradeBinTable(db);
    _UpgradeAidTable(db);
    _UpgradePubKeyTable(db);
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<Map<String, dynamic>> queryById(String table, int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rowList = await db.query(table, where: 'id=$id');
    if (rowList.length != 0) {
      return rowList[0];
    } else
      return null;
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll(String table) async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> deleteRows(String table, {String where, List<dynamic> whereArgs}) async {
    Database db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> queryRowCountArguments(String table, {String where}) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE $where'));
  }
}
