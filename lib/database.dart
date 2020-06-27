import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "app.db";
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
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  void _tableAlter(Database db, String table, String column, String type) async {
    if (type.compareTo('text') == 0)
      await db.execute('''alter table $table add column $column $type DEFAULT ' ' ''');
    else
      await db.execute('''alter table $table add column $column $type DEFAULT '0' ''');
  }

  void _CreateMerchantTable(Database db) async {
    await db.execute('''
          CREATE TABLE merchant (
          Name TEXT DEFAULT ' ')
          ''');

    await _tableAlter(db, 'merchant', 'TID', 'text');
    await _tableAlter(db, 'merchant', 'MID', 'text');
    await _tableAlter(db, 'merchant', 'CurrencyCode', 'integer');
    await _tableAlter(db, 'merchant', 'CurrencySymbol', 'text');
    await _tableAlter(db, 'merchant', 'Password', 'text');
    await _tableAlter(db, 'merchant', 'Header', 'text');
    await _tableAlter(db, 'merchant', 'Amount_MaxDigtis', 'integer');
    await _tableAlter(db, 'merchant', 'Amount_DecimalPosition', 'integer');
    await _tableAlter(db, 'merchant', 'BatchNumber', 'integer');
    await _tableAlter(db, 'merchant', 'MaxTip', 'integer');
    await _tableAlter(db, 'merchant', 'Address', 'text');
    await _tableAlter(db, 'merchant', 'TaxID', 'text');

  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await _CreateMerchantTable(db);

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
    List<Map<String, dynamic>> MerchantList = await db.query(table, where: 'rowid=$id');
    return MerchantList[0];
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(table, row, where: 'rowid = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'rowid = ?', whereArgs: [id]);
  }
}