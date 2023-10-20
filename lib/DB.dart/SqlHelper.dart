import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE items 
      (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      title TEXT, 
      description INTEGER,
      status INTEGER,  
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  static Future<int> createItem(String title, String? descrption) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'status': 0
    }; //0 matlab job has not been done till now
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace); //We used conflictAlgorithm to avoid any kind duplication data entry.
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SqlHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption, int? status) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'status': status,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SqlHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
