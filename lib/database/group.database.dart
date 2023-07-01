import 'package:fraction/model/group.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void getGroup() async {
  final database = await openDatabase(join(await getDatabasesPath(), 'group'),
      onCreate: (db, version) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS group(
        groupName TEXT
      )
    ''');
  }, version: 1);

  final db = await database;

  Map group = await db.query('group') as Map<String, dynamic>;
}

void insertGroupIntoLocalDatabase(Group group) async {
  final database = await openDatabase(join(await getDatabasesPath(), 'group'),
      onCreate: (db, version) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS group(
        groupName TEXT
      )
    ''');
  });

  final db = await database;

  await db.insert('group', group.toMap()).onError((error, stackTrace) {
    throw {'error': error};
  });
}
