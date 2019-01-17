import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _connection;
  String databasePath;

  DatabaseHelper.internal();

  Future<Database> get connection async {
    if (_connection != null) {
      return _connection;
    }

    _connection = await initDatabase();

    return _connection;
  }

  initDatabase() async {
    String databasePath = await getDatabasesPath();

    databasePath = join(databasePath, "todo.db");
//    await deleteDatabase(databasePath);
    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void getDBPath() async {
    var d = await connection;
  }

  void _onCreate(Database db, int version) async {
    String creatTableSql =
        'Create table if not exists todo('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title TEXT,'
        'description TEXT,'
        'longitude TEXT, '
        'latitude TEXT,'
        'startTime INTEGER,'
        'endTime INTEGER,'
        'priority INTEGER);';

    await db.execute(creatTableSql);
  }

  /// Get a todo item by its id, if there is not entry for that ID, returns null.
  Future<Item> getItem(int id) async{
    var db = await connection;
    var result = await db.rawQuery('SELECT * FROM todo WHERE ${Item.idCol} = "$id"');
    if(result.length == 0)return null;
    return Item.from(result[0]);
  }

  // delete a particular item
  Future<bool> removeItem(int id) async{
    var db = await connection;
    var result = await db.rawQuery('DELETE FROM todo WHERE ${Item.idCol} = $id');
    return true;
  }

  Future<bool> addItem({title, description}) async{
    var db = await connection;

    var insertedTime = DateTime.now().millisecondsSinceEpoch;

    var result = await db.rawQuery('INSERT INTO todo(title, description, startTime) values(\'$title\', \'$description\', $insertedTime)');
    return true;
  }

  Future<bool> updateItem({id, title, description}) async{
    var db = await connection;

    var result = await db.rawQuery('UPDATE todo set title = \'$title\', description = \'$description\' WHERE id = $id');
    return true;
  }


  /// Get all items, will return a list
  Future<List<Item>> getAllItems() async{
    var db = await connection;
    var result = await db.rawQuery('SELECT * FROM todo order by id asc');
    List<Item> items = [];
    for(Map<String, dynamic> item in result) {
      items.add(Item.from(item));
    }
    return items;
  }
}