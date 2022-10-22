import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE PLACES (ID TEXT PRIMARY KEY, TITLE TEXT, IMAGEPATH TEXT, LAT REAL, LNG REAL, ADDRESS TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> delete(String table, String id) async {
    final db = await database();
    await db.delete(table, where: 'ID = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> select(String table) async {
    final db = await database();
    return db.query(table);
  }
}
