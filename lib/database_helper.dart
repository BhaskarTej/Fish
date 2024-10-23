// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'aquarium.db';
  static final _databaseVersion = 1;
  static final table = 'settings';
  static final columnId = '_id';
  static final columnFishCount = 'fish_count';
  static final columnSpeed = 'speed';
  static final columnColor = 'color';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnFishCount INTEGER NOT NULL,
        $columnSpeed REAL NOT NULL,
        $columnColor TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveSettings(int fishCount, double speed, String color) async {
    Database db = await instance.database;
    await db.insert(
      table,
      {
        columnFishCount: fishCount,
        columnSpeed: speed,
        columnColor: color,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getSettings() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(table);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
