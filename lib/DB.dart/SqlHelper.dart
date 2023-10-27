import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SqlHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE items1 
      (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      title TEXT, 
      description INTEGER,
      status INTEGER,
      category TEXT,  
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech1.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  static Future<int> createItem(String title, String? descrption,String category) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'status': 0,
      'category': category
    }; //0 matlab job has not been done till now
    final id = await db.insert('items1', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace); //We used conflictAlgorithm to avoid any kind duplication data entry.
    return id;
  }
 //get single and multiple items
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SqlHelper.db();
    return db.query('items1', where: "id = ?", whereArgs: [id], limit: 1);
  }
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('items1');
  }
  //filter items
  static Future<List<Map<String, dynamic>>> filterGetCompleteditem(int status, String category) async {
    final db = await SqlHelper.db();
    return db.query('items1', where: "status = ? AND category = ?", whereArgs: [status, category],orderBy: "id");
  }
    static Future<List<Map<String, dynamic>>> filterGetPendingItems(int status, String category) async {
    final db = await SqlHelper.db();
    return db.query('items1',where: "status = ? AND category = ?", whereArgs: [status, category], orderBy: "id");
  }
  //get pending or completed items
  static Future<List<Map<String, dynamic>>> getcompleteditem(int status) async {
    final db = await SqlHelper.db();
    return db.query('items1', where: "status = ?", whereArgs: [status],orderBy: "id");
  }
    static Future<List<Map<String, dynamic>>> getpendingItems(int status) async {
    final db = await SqlHelper.db();
    return db.query('items1',where: "status = ?", whereArgs: [status], orderBy: "id");
  }
  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption, int? status,String category) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'status': status,
      'category': category,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('items1', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SqlHelper.db();
    try {
      await db.delete("items1", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
