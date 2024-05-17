import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper3 {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'usersdb.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usersdb(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        email TEXT UNIQUE,
        phone_number TEXT UNIQUE,
        gender TEXT,
        role TEXT,
        profile_pic_path TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> userdb) async {
    Database? db = await database;
    return await db!.insert('usersdb', userdb);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database? db = await database;
    return await db!.query('usersdb');
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db?.delete('usersdb', where: 'id = ?', whereArgs: [id]) ?? 0;
  }

  Future<void> updateUser(int userId, String fullName, String phoneNumber, String email, String gender, String role, String profilePicPath) async {
    Database? db = await database;
    await db!.update(
      'usersdb',
      {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'email': email,
        'gender': gender,
        'role': role,
        'profile_pic_path': profilePicPath,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    Database? db = await database;
    List<Map<String, dynamic>> result = await db!.query('usersdb', where: 'id = ?', whereArgs: [userId]);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('User with ID $userId not found');
    }
  }
}
