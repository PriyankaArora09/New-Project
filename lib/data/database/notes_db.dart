// ignore_for_file: depend_on_referenced_packages

import 'package:demo/data/models/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
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
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      deltaJsonBody TEXT,
      pinLock TEXT,
      hasAttachments INTEGER,
      hasCanvas INTEGER,
      backgroundColor INTEGER,
      isPinned INTEGER,
      isBookmarked INTEGER,
      isArchieved INTEGER,
      isTrash INTEGER,
      isLocked INTEGER,
      attachments TEXT,
      canvasData TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      category INTEGER,
      url TEXT
    )
    ''');
  }

  Future<int> insertNote(Notes note) async {
    final db = await instance.database;
    final noteMap = note.toMap();
    noteMap.remove('id'); // Let DB auto-generate id
    return await db.insert('notes', noteMap);
  }

  Future<void> updateNote(Notes note) async {
    final db = await instance.database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Notes>> getAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes');
    return result.map((map) => Notes.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}