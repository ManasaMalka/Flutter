import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      debugPrint('Using existing database instance');
      return _database!;
    }
    debugPrint('Initializing new database instance');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize the database factory
    debugPrint('Initializing database factory');
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');

      // open the database
      Database database = await openDatabase(path, version: 3,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Individuals (id INTEGER PRIMARY KEY, full_name TEXT, email TEXT, phone_number TEXT, gender TEXT, password TEXT)');
      });

      return database;
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow; // Rethrow the error to propagate it further
    }

    // databaseFactory = databaseFactoryFfi;

    // try {
    //   var databasesPath = await getDatabasesPath();
    //   String path = join(databasesPath, 'users.db');
    //   print('Opening database at $path');
    //   var database = await databaseFactory.openDatabase(path);
    //   print('Database initialized successfully');
    //   return database;
    // } catch (e) {
    //   print('Error initializing database: $e');
    //   rethrow; // Rethrow the error to propagate it further
    // }
  }

  Future<int> insertUser(User user) async {
    final db = await instance.database;
    debugPrint('Inserting user into database');
    return await db.insert(
      'Individuals',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    debugPrint('Querying user by email: $email');
    List<Map<String, dynamic>> maps = await db.query(
      'Individuals',
      where: 'email = ?',
      whereArgs: [email],
      columns: [
        'id',
        'full_name',
        'email',
        'phone_number',
        'gender',
        'password'
      ],
    );
    if (maps.isEmpty) {
      debugPrint('User not found for email: $email');
      return null;
    } else {
      debugPrint('User found for email: $email');
      return User.fromMap(maps.first);
    }
  }

  Future<User?> getUserByPhone(String phoneNumber) async {
    final db = await instance.database;
    debugPrint('Querying user by phone number: $phoneNumber');
    List<Map<String, dynamic>> maps = await db.query(
      'Individuals',
      where: 'phone_number = ?',
      whereArgs: [phoneNumber],
      columns: [
        'id',
        'full_name',
        'email',
        'phone_number',
        'gender',
        'password'
      ],
    );
    if (maps.isEmpty) {
      debugPrint('User not found for phone number: $phoneNumber');
      return null;
    } else {
      debugPrint('User found for phone number: $phoneNumber');
      return User.fromMap(maps.first);
    }
  }
}
