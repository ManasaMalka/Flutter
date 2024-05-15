import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/user.dart';


class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      print('Using existing database instance');
      return _database!;
    }
    print('Initializing new database instance');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize the database factory
    print('Initializing database factory');
    databaseFactory = databaseFactoryFfi;

    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'users.db');
      print('Opening database at $path');
      var database = await databaseFactory.openDatabase(path);
      print('Database initialized successfully');
      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow; // Rethrow the error to propagate it further
    }
  }

  Future<int> insertUser(User user) async {
    final db = await instance.database;
    print('Inserting user into database');
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    print('Querying user by email: $email');
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      columns: ['id', 'full_name', 'email', 'phone_number', 'gender', 'password'],
    );
    if (maps.isEmpty) {
      print('User not found for email: $email');
      return null;
    } else {
      print('User found for email: $email');
      return User.fromMap(maps.first);
    }
  }

  Future<User?> getUserByPhone(String phoneNumber) async {
    final db = await instance.database;
    print('Querying user by phone number: $phoneNumber');
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'phone_number = ?',
      whereArgs: [phoneNumber],
      columns: ['id', 'full_name', 'email', 'phone_number', 'gender', 'password'],
    );
    if (maps.isEmpty) {
      print('User not found for phone number: $phoneNumber');
      return null;
    } else {
      print('User found for phone number: $phoneNumber');
      return User.fromMap(maps.first);
    }
  }
}
