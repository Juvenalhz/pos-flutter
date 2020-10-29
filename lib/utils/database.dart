import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "test28.db";
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

  Future<void> _createMerchantTable(Database db) async {
    await db.execute('''
          CREATE TABLE merchant (
          id integer PRIMARY KEY AUTOINCREMENT,
          NameL1 TEXT DEFAULT '')
          ''');
    _upgradeMerchantTable(db);
  }

  void _upgradeMerchantTable(Database db) async {
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
    _tableAlter(db, 'merchant', 'AcquirerCode', 'integer');
  }

  void _createTerminalTable(Database db) async {
    await db.execute('''
          CREATE TABLE terminal (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeTerminalTable(db);
  }

  void _upgradeTerminalTable(Database db) async {
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
    _tableAlter(db, 'terminal', 'print', 'integer');
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

  void _createCommTable(Database db) async {
    await db.execute('''
          CREATE TABLE comm (
          id integer PRIMARY KEY AUTOINCREMENT,
          Name TEXT DEFAULT '')
          ''');

    _upgradeCommTable(db);
  }

  void _upgradeCommTable(Database db) async {
    _tableAlter(db, 'comm', 'tpdu', 'text');
    _tableAlter(db, 'comm', 'nii', 'text');
    _tableAlter(db, 'comm', 'timeout', 'integer');
    _tableAlter(db, 'comm', 'ip', 'text');
    _tableAlter(db, 'comm', 'port', 'integer');
    _tableAlter(db, 'comm', 'headerLength', 'integer');
  }

  void _createEmvTable(Database db) async {
    await db.execute('''
          CREATE TABLE emv (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeEmvTable(db);
  }

  void _upgradeEmvTable(Database db) async {
    _tableAlter(db, 'emv', 'terminalType', 'text');
    _tableAlter(db, 'emv', 'terminalCapabilities', 'text');
    _tableAlter(db, 'emv', 'addTermCapabilities', 'text');
    _tableAlter(db, 'emv', 'fallback', 'integer');
    _tableAlter(db, 'emv', 'forceOnline', 'integer');
    _tableAlter(db, 'emv', 'currencyCode', 'integer');
    _tableAlter(db, 'emv', 'countryCode', 'integer');
  }

  void _createCountersTable(Database db) async {
    await db.execute('''
          CREATE TABLE counters (
          id integer PRIMARY KEY,
          stan integer )
          ''');
  }

  void _upgradeCountersTable(Database db) async {}

  void _createAcquirerTable(Database db) async {
    await db.execute('''
          CREATE TABLE acquirer (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeAcquirerTable(db);
  }

  void _upgradeAcquirerTable(Database db) async {
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
    _tableAlter(db, 'acquirer', 'passwordRefund', 'integer');
    _tableAlter(db, 'acquirer', 'maskPan', 'integer');
    _tableAlter(db, 'acquirer', 'prePrint', 'integer');
    _tableAlter(db, 'acquirer', 'manualEntry', 'integer');
  }

  void _createBinTable(Database db) async {
    await db.execute('''
          CREATE TABLE bin (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeBinTable(db);
  }

  void _upgradeBinTable(Database db) async {
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

  void _createAidTable(Database db) async {
    await db.execute('''
          CREATE TABLE aid (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeAidTable(db);
  }

  void _upgradeAidTable(Database db) async {
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

  void _createPubKeyTable(Database db) async {
    await db.execute('''
          CREATE TABLE pubkey (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradePubKeyTable(db);
  }

  void _upgradePubKeyTable(Database db) async {
    _tableAlter(db, 'pubkey', 'keyIndex', 'integer');
    _tableAlter(db, 'pubkey', 'rid', 'text');
    _tableAlter(db, 'pubkey', 'exponent', 'text');
    _tableAlter(db, 'pubkey', 'expDate', 'text');
    _tableAlter(db, 'pubkey', 'length', 'integer');
    _tableAlter(db, 'pubkey', 'modulus', 'text');
  }

  void _createTransTable(Database db) async {
    await db.execute('''
          CREATE TABLE trans (
          id integer PRIMARY KEY AUTOINCREMENT )
          ''');

    _upgradeTransTable(db);
  }

  void _upgradeTransTable(Database db) async {
    _tableAlter(db, 'trans', 'id', 'integer');
    _tableAlter(db, 'trans', 'number', 'integer');
    _tableAlter(db, 'trans', 'stan', 'integer');
    _tableAlter(db, 'trans', 'dateTime', 'text');
    _tableAlter(db, 'trans', 'type', 'text');
    _tableAlter(db, 'trans', 'reverse', 'integer');
    _tableAlter(db, 'trans', 'advice', 'integer');
    _tableAlter(db, 'trans', 'acquirer', 'integer');
    _tableAlter(db, 'trans', 'bin', 'integer');
    _tableAlter(db, 'trans', 'maskedPAN', 'text');
    _tableAlter(db, 'trans', 'cipheredPAN', 'text');
    _tableAlter(db, 'trans', 'panHash', 'text');
    _tableAlter(db, 'trans', 'cipheredCardHolderName', 'text');
    _tableAlter(db, 'trans', 'cipheredTrack2', 'text');
    _tableAlter(db, 'trans', 'expDate', 'text');
    _tableAlter(db, 'trans', 'serviceCode', 'text');
    _tableAlter(db, 'trans', 'currency', 'integer');
    _tableAlter(db, 'trans', 'entryMode', 'integer');
    _tableAlter(db, 'trans', 'baseAmount', 'integer');
    _tableAlter(db, 'trans', 'tip', 'integer');
    _tableAlter(db, 'trans', 'tax', 'integer');
    _tableAlter(db, 'trans', 'cashback', 'integer');
    _tableAlter(db, 'trans', 'total', 'integer');
    _tableAlter(db, 'trans', 'originalTotal', 'integer');
    _tableAlter(db, 'trans', 'responseCode', 'text');
    _tableAlter(db, 'trans', 'authNumber', 'text');
    _tableAlter(db, 'trans', 'hostRRN', 'text');
    _tableAlter(db, 'trans', 'emvTags', 'text');
    _tableAlter(db, 'trans', 'appType', 'integer');
    _tableAlter(db, 'trans', 'cardType', 'integer');
    _tableAlter(db, 'trans', 'panSequenceNumber', 'integer');
    _tableAlter(db, 'trans', 'cardholderName', 'text');
    _tableAlter(db, 'trans', 'appLabel', 'text');
    _tableAlter(db, 'trans', 'aidID', 'integer');
    _tableAlter(db, 'trans', 'responseEmvTags', 'text');
    _tableAlter(db, 'trans', 'cardDecision', 'integer');
    _tableAlter(db, 'trans', 'finishTags', 'text');
    _tableAlter(db, 'trans', 'cardholderID', 'text');
    _tableAlter(db, 'trans', 'accType', 'integer');
    _tableAlter(db, 'trans', 'signature', 'integer');
    _tableAlter(db, 'trans', 'offlinePIN', 'integer');
    _tableAlter(db, 'trans', 'blockedPIN', 'integer');
    _tableAlter(db, 'trans', 'onlinePIN', 'integer');
    _tableAlter(db, 'trans', 'referenceNumber', 'text');
    _tableAlter(db, 'trans', 'authCode', 'text');
    _tableAlter(db, 'trans', 'respCode', 'text');
    _tableAlter(db, 'trans', 'batchNum', 'integer');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    _createMerchantTable(db);
    _createTerminalTable(db);
    _createCommTable(db);
    _createEmvTable(db);
    _createCountersTable(db);
    _createAcquirerTable(db);
    _createBinTable(db);
    _createAidTable(db);
    _createPubKeyTable(db);
    _createTransTable(db);

    Map<String, dynamic> initialCounter = {
      'id': 1,
      'stan': 1,
    };

    await db.insert('counters', initialCounter);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _upgradeMerchantTable(db);
    _upgradeTerminalTable(db);
    _upgradeCommTable(db);
    _upgradeEmvTable(db);
    _upgradeCountersTable(db);
    _upgradeAcquirerTable(db);
    _upgradeBinTable(db);
    _upgradeAidTable(db);
    _upgradePubKeyTable(db);
    _upgradeTransTable(db);
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

  Future<List<Map<String, dynamic>>> queryAllRows(String table, {String where}) async {
    Database db = await instance.database;
    return await db.query(table, where: where);
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
