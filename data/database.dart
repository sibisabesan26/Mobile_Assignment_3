import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'food_ordering.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE food_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            price REAL NOT NULL CHECK(price >= 0)
          );
        ''');

        await database.execute('''
          CREATE TABLE order_plans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            target_cost REAL NOT NULL CHECK(target_cost >= 0)
          );
        ''');

        await database.execute('''
          CREATE TABLE  (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plan_id INTEGER NOT NULL,
            food_item_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL CHECK(quantity > 0),
            FOREIGN KEY(plan_id) REFERENCES order_plans(id) ON DELETE CASCADE,
            FOREIGN KEY(food_item_id) REFERENCES food_items(id) ON DELETE RESTRICT
          );
        ''');

        // Enable foreign keys
        await database.execute('PRAGMA foreign_keys = ON;');
      },
      onOpen: (database) async {
        await database.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }
}
