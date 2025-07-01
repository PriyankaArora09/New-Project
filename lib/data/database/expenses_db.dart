// ignore_for_file: depend_on_referenced_packages

import 'package:demo/data/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpensesDb {
  static final ExpensesDb instance = ExpensesDb._init();

  static Database? _database;

  ExpensesDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        currency TEXT,
        description TEXT,
        hasAttachments INTEGER,
        attachments TEXT,
        isPinned INTEGER,
        isArchived INTEGER,
        isTrash INTEGER,
        isRecurring INTEGER,
        recurringFrequency TEXT,
        paymentMethod TEXT,
        notes TEXT,
        category INTEGER,
        expenseDate TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        subExpenses TEXT
      )
    ''');
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await instance.database;
    final expenseMap = expense.toMap();
    expenseMap.remove('id'); // id will auto-increment
    return await db.insert('expenses', expenseMap);
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await instance.database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await instance.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await instance.database;
    final result = await db.query('expenses');
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
