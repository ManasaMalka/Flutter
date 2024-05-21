import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      print('Using existing database instance');
      return _database;
    }
    print('Initializing new database instance');
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'users.db');
      print('Opening database at $path');
      var database = await openDatabase(path, version: 1, onCreate: _createDB);

      print('Database initialized successfully');
      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; 
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        email TEXT UNIQUE,
        phone_number TEXT UNIQUE,
        gender TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database? db = await database;
    return await db!.insert('users', user);
  }

 

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database? db = await database;
    return await db!.query('users');
  }

  Future<List<Map<String, dynamic>>> getUserByEmailOrPhoneNumber(String emailOrPhoneNumber) async {
  Database? db = await database;
  return await db!.query('users', where: 'email = ? OR phone_number = ?', whereArgs: [emailOrPhoneNumber, emailOrPhoneNumber]);
}


Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
  Database? db = await database;
  if (db != null) {
    return await db.query('users', where: 'email = ?', whereArgs: [email]);
  } else {
    // Handle the case where database is null
    return [];
  }
}

Future<List<Map<String, dynamic>>> getUserByPhoneNumber(String phoneNumber) async {
  Database? db = await database;
  if (db != null) {
    return await db.query('users', where: 'phone_number = ?', whereArgs: [phoneNumber]);
  } else {
    // Handle the case where database is null
    return [];
  }
}

}
