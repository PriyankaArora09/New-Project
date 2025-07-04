// ignore_for_file: depend_on_referenced_packages

import 'package:demo/data/models/password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordDb {
  static final PasswordDb instance = PasswordDb._init();

  static Database? _database;

  PasswordDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('passwords.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE passwords (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      username TEXT,
      password TEXT,
      notes TEXT,
      has2FA INTEGER,
      twoFactorSecret TEXT,
      
      isPinned INTEGER,
     
      isArchieve INTEGER,
      isTrash INTEGER,

      createdAt TEXT,
      updatedAt TEXT,
      category INTEGER,
      website TEXT
    )
    ''');
  }

  Future<int> insertPassword(Password password) async {
    final db = await instance.database;
    final passwordMap = password.toMap();
    passwordMap.remove('id'); // Let DB auto-generate id
    return await db.insert('passwords', passwordMap);
  }

  Future<void> updatePassword(Password password) async {
    final db = await instance.database;
    await db.update('passwords', password.toMap(),
        where: 'id = ?', whereArgs: [password.id]);
  }

  Future<void> deletePassword(int id) async {
    final db = await instance.database;
    await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Password>> getAllPasswords() async {
    final db = await instance.database;
    final result = await db.query('passwords');
    return result.map((map) => Password.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
