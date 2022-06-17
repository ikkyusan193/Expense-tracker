import 'dart:core';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// SQLite tutorials
// https://www.youtube.com/watch?v=UpKrhZ0Hppk
// https://docs.flutter.dev/cookbook/persistence/sqlite
class DatabaseHelper {

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDB('EXPENSE_DATABASE.db');
    return _database!;
  }

  factory DatabaseHelper() => instance;

  Future<Database> _initDB(String filePath) async{
    final database = openDatabase(
      join(await getDatabasesPath(), filePath),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE EXPENSE(id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'date INTEGER NOT NULL, '
                'name TEXT NOT NULL, '
                'category TEXT NOT NULL ,'
                'cost INTEGER NOT NULL, '
                'note TEXT)');
      },
      version: 1,
    );
    return database;
  }

}
