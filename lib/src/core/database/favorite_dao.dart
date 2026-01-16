import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class FavoriteDao {
  Future<void> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase.database;
    await db.insert(
      'favorites',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase.database;
    return db.query('favorites');
  }

  Future<bool> isFavorite(int id) async {
    final db = await AppDatabase.database;
    final res = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty;
  }
}
