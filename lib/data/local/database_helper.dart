import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblBoomark = 'bookmarks';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tblBoomark (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            city TEXT,
            pictureId TEXT,
            rating DOUBLE
          )
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  Future<void> insertBookmark(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblBoomark, restaurant.toJson());
  }

  Future<List<Restaurant>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBoomark);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getBookmarkById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tblBoomark,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBookmark(String id) async {
    final db = await database;
    await db!.delete(
      _tblBoomark,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
