import 'package:fraction/model/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void insertExpense(ExpenseModel expense) async {
  const bool kDebugMode = true;
  try {
    final database = await openDatabase(
        join(await getDatabasesPath(), 'expense'), onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE IF NOT EXISTS expense(
          group_id TEXT,
          email_id TEXT,
          description VARCHAR2(50),
          cost INTEGER,
          timestamp TEXT
        )
    ''');
    }, version: 1);

    final db = await database;

    await db.insert('expense', expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (e) {
    if (kDebugMode) {
      print('-------- error inserting profile --------');
      print('-------- $e --------');
    }
  }
}

Future<List<Map<String, dynamic>>> getExpenseDetials() async {
  const bool kDebugMode = true;

  try {
    final database = await openDatabase(
        join(await getDatabasesPath(), 'expense'), onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE IF NOT EXISTS expense(
          group_id TEXT,
          email_id TEXT,
          description VARCHAR2(50),
          cost INTEGER,
          timestamp TEXT
        )
    ''');
    }, version: 1);

    final db = await database;

    final List<Map<String, dynamic>> map =
        await db.query('expense').whenComplete(() => db.close());

    return map;
  } catch (e) {
    if (kDebugMode) {
      print('-------- error inserting profile --------');
      print('-------- $e --------');
    }
  }

  return [];
}
