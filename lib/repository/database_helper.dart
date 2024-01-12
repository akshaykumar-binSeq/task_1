import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/item_model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the items table
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            full_name TEXT,
            created_at DATETIME,
            updated_at DATETIME,
            pushed_at DATETIME
          )
        ''');
      },
    );
  }

  static Future<bool> batchInsertItems(List<Items> items) async {
    try {
      final db = await database;

      Batch batch = db.batch();
      for (Items item in items) {
        batch.insert('items', item.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit();
      return true;
    } catch (e) {
      log('Error batch inserting items: $e');
      return false;
    }
  }

  static Future<List<Items>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Items.fromJson(maps[i]);
    });
  }
}
