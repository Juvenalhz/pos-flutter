import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "test10.db";
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
    }
    catch (e) {}
  }

  void _CreateMerchantTable(Database db) async {
    await db.execute('''
          CREATE TABLE merchant (
          id integer PRIMARY KEY AUTOINCREMENT,
          Name TEXT DEFAULT '')
          ''');

    _tableAlter(db, 'merchant', 'TID', 'text');
    _tableAlter(db, 'merchant', 'MID', 'text');
    _tableAlter(db, 'merchant', 'CurrencyCode', 'integer');
    _tableAlter(db, 'merchant', 'CurrencySymbol', 'text');
    _tableAlter(db, 'merchant', 'Password', 'text');
    _tableAlter(db, 'merchant', 'Header', 'text');
    _tableAlter(db, 'merchant', 'Amount_MaxDigtis', 'integer');
    _tableAlter(db, 'merchant', 'Amount_DecimalPosition', 'integer');
    _tableAlter(db, 'merchant', 'BatchNumber', 'integer');
    _tableAlter(db, 'merchant', 'MaxTip', 'integer');
    _tableAlter(db, 'merchant', 'Address', 'text');
    _tableAlter(db, 'merchant', 'TaxID', 'text');
    _tableAlter(db, 'merchant', 'Logo', 'text');

  }

  void _UpgradeMerchantTable(Database db) async {
    _tableAlter(db, 'merchant', 'TID', 'text');
    _tableAlter(db, 'merchant', 'MID', 'text');
    _tableAlter(db, 'merchant', 'CurrencyCode', 'integer');
    _tableAlter(db, 'merchant', 'CurrencySymbol', 'text');
    _tableAlter(db, 'merchant', 'Password', 'text');
    _tableAlter(db, 'merchant', 'Header', 'text');
    _tableAlter(db, 'merchant', 'Amount_MaxDigtis', 'integer');
    _tableAlter(db, 'merchant', 'Amount_DecimalPosition', 'integer');
    _tableAlter(db, 'merchant', 'BatchNumber', 'integer');
    _tableAlter(db, 'merchant', 'MaxTip', 'integer');
    _tableAlter(db, 'merchant', 'Address', 'text');
    _tableAlter(db, 'merchant', 'TaxID', 'text');
    _tableAlter(db, 'merchant', 'Logo', 'text');
  }

  void _CreateTerminalTable(Database db) async {
    await db.execute('''
          CREATE TABLE terminal (
          id integer PRIMARY KEY AUTOINCREMENT,
          Name TEXT DEFAULT '')
          ''');

    _tableAlter(db, 'terminal', 'password', 'text');
    _tableAlter(db, 'terminal', 'techPassword', 'text');
    _tableAlter(db, 'terminal', 'id', 'text');
    _tableAlter(db, 'terminal', 'kin', 'text');
    _tableAlter(db, 'terminal', 'minPinDigits', 'text');
    _tableAlter(db, 'terminal', 'maxPinDigits', 'text');
    _tableAlter(db, 'terminal', 'timeoutPrompt', 'text');
    _tableAlter(db, 'terminal', 'maxTipPercentage', 'text');
    _tableAlter(db, 'terminal', 'keyIndex', 'text');
    _tableAlter(db, 'terminal', 'industry', 'text');
    _tableAlter(db, 'terminal', 'print', 'text');
    _tableAlter(db, 'terminal', 'cashback', 'text');
    _tableAlter(db, 'terminal', 'installments', 'text');
    _tableAlter(db, 'terminal', 'refund', 'text');
    _tableAlter(db, 'terminal', 'last4Digits', 'text');
    _tableAlter(db, 'terminal', 'passwordVoid', 'text');
    _tableAlter(db, 'terminal', 'passwordBatch', 'text');
    _tableAlter(db, 'terminal', 'passwordRefund', 'text');
    _tableAlter(db, 'terminal', 'maskPan', 'text');
    _tableAlter(db, 'terminal', 'amountConfirmation', 'text');
  }

  void _UpgradeTerminalTable(Database db) async {
    _tableAlter(db, 'terminal', 'password', 'text');
    _tableAlter(db, 'terminal', 'techPassword', 'text');
    _tableAlter(db, 'terminal', 'id', 'text');
    _tableAlter(db, 'terminal', 'kin', 'text');
    _tableAlter(db, 'terminal', 'minPinDigits', 'text');
    _tableAlter(db, 'terminal', 'maxPinDigits', 'text');
    _tableAlter(db, 'terminal', 'timeoutPrompt', 'text');
    _tableAlter(db, 'terminal', 'maxTipPercentage', 'text');
    _tableAlter(db, 'terminal', 'keyIndex', 'text');
    _tableAlter(db, 'terminal', 'industry', 'text');
    _tableAlter(db, 'terminal', 'print', 'text');
    _tableAlter(db, 'terminal', 'cashback', 'text');
    _tableAlter(db, 'terminal', 'installments', 'text');
    _tableAlter(db, 'terminal', 'refund', 'text');
    _tableAlter(db, 'terminal', 'last4Digits', 'text');
    _tableAlter(db, 'terminal', 'passwordVoid', 'text');
    _tableAlter(db, 'terminal', 'passwordBatch', 'text');
    _tableAlter(db, 'terminal', 'passwordRefund', 'text');
    _tableAlter(db, 'terminal', 'maskPan', 'text');
    _tableAlter(db, 'terminal', 'amountConfirmation', 'text');
  }

  void _CreateCommTable(Database db) async {
    await db.execute('''
          CREATE TABLE comm (
          id integer PRIMARY KEY AUTOINCREMENT,
          Name TEXT DEFAULT '')
          ''');

    _tableAlter(db, 'comm', 'tpdu', 'text');
    _tableAlter(db, 'comm', 'nii', 'text');
    _tableAlter(db, 'comm', 'timout', 'text');
    _tableAlter(db, 'comm', 'ip', 'text');
    _tableAlter(db, 'comm', 'port', 'text');
  }

  void _UpgradeCommTable(Database db) async {
    _tableAlter(db, 'comm', 'tpdu', 'text');
    _tableAlter(db, 'comm', 'nii', 'text');
    _tableAlter(db, 'comm', 'timout', 'text');
    _tableAlter(db, 'comm', 'ip', 'text');
    _tableAlter(db, 'comm', 'port', 'text');
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    _CreateMerchantTable(db);
    _CreateTerminalTable(db);

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _UpgradeMerchantTable(db);
    _UpgradeTerminalTable(db);
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
    }
    else
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

}