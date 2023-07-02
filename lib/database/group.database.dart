import 'package:fraction/model/group.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> getGroupNamesFromLocalDatabase() async {
  final database = await openDatabase(join(await getDatabasesPath(), 'group'),
      onCreate: (db, version) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS group(
        groupName TEXT
      )
    ''');
  }, version: 1);

  final db = await database;

  Map groupTable = await db.query('group') as Map<String, dynamic>;
  print(groupTable);
  // return GroupModel(groupName: groupTable['groupNames']);
}

void insertGroupIntoLocalDatabase(GroupModel listGroupNames) async {
  final database = await openDatabase(join(await getDatabasesPath(), 'group'),
      onCreate: (db, version) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS group(
        groupName TEXT
      )
    ''');
  });

  final db = await database;

  for (String group in listGroupNames.toMap()['groupNames']) {
    await db.insert('group', {'groupName': group}).onError((error, stackTrace) {
      throw {'error': error};
    });
  }
}
