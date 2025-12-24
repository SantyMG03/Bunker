import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseHelper {
  /// Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Getter for the database, initializes if null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bunker_vault.db');
    return _database!;
  }

  /// Initializes the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    // Encrypt the database with a password
    // If wanted a real app (V2), the password should be given from login user input
    const pswd = 'bunker-secret-key';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      password: pswd, // Encrypts the file with the given password
    );
  }

  /// Creates the database schema
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE passwords (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      user_name TEXT NOT NULL,
      encrypted_password TEXT NOT NULL,
      notes TEXT,
      created_at TEXT NOT NULL
    )
    ''');
  }

  // ===== CRUD Operations =====


  /// Inserts a new secret into the database
  Future<int> create(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('passwords', row);
  }

  /// Retrieves all secrets from the database
  Future<List<Map<String, dynamic>>> readAllPasswords() async {
    final db = await instance.database;
    return await db.query('passwords', orderBy: 'created_at DESC');
  }

  /// Deletes a secret by ID
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
