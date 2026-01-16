import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'rick_morty.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            species TEXT,
            gender TEXT,
            status TEXT,
            origin TEXT,
            location TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Safer approach: recreate table with new schema
          // First, backup existing data
          final List<Map<String, dynamic>> existingData = await db.query(
            'favorites',
          );

          // Drop old table
          await db.execute('DROP TABLE IF EXISTS favorites');

          await db.execute('''
            CREATE TABLE favorites (
              id INTEGER PRIMARY KEY,
              name TEXT,
              image TEXT,
              species TEXT,
              gender TEXT,
              status TEXT,
              origin TEXT,
              location TEXT
            )
          ''');

          for (var row in existingData) {
            await db.insert('favorites', {
              'id': row['id'],
              'name': row['name'],
              'image': row['image'],
              'species': row['species'],
              'gender': row['gender'],
              'status': row['status'] ?? '',
              'origin': row['origin'] ?? '',
              'location': row['location'] ?? '',
            });
          }
        }
      },
    );
  }
}
