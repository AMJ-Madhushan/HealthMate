import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/health_record.dart';

class HealthRecordDb {
  static const _dbName = 'healthmate.db';
  static const _dbVersion = 1;
  static const tableName = 'health_records';

  HealthRecordDb._internal();
  static final HealthRecordDb instance = HealthRecordDb._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        water INTEGER NOT NULL
      )
    ''');

    await db.insert(tableName, {
      'date': '2025-11-28',
      'steps': 5000,
      'calories': 1800,
      'water': 1500,
    });

    await db.insert(tableName, {
      'date': '2025-11-29',
      'steps': 8000,
      'calories': 2100,
      'water': 2000,
    });
  }

  Future<int> insertRecord(HealthRecord record) async {
    final db = await database;
    return db.insert(
      tableName,
      record.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final result = await db.query(
      tableName,
      orderBy: 'date DESC',
    );
    return result.map((e) => HealthRecord.fromMap(e)).toList();
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await database;
    return db.update(
      tableName,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
