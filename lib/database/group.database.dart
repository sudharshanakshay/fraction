import 'package:fraction/model/group.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<GroupModel> getGroupNamesFromLocalDatabase() async {
  final database = await openDatabase(join(await getDatabasesPath(), 'group'));
  final db = database;

  Map groupTable = await db.query('group') as Map<String, dynamic>;
  return GroupModel(groupMembers: groupTable['groupNames']);
}

void insertGroupIntoLocalDatabase(GroupModel listGroupNames) async {
  // print('---- insertGroupTolocalDatabase func, $listGroupNames ----');
  // final database = await openDatabase(join(await getDatabasesPath(), 'group'),
  //     onCreate: (db, version) {
  //   return db.execute('CREATE TABLE IF NOT EXISTS group (groupName TEXT)');
  // }, version: 1);

  // final db = database;

  // for (String group in listGroupNames.toMap()['groupNames']) {
  //   print(' ---- inserting $group into group table ----');
  //   await db.insert('group', {'groupName': group}).onError((error, stackTrace) {
  //     throw {'error': error};
  //   });
  // }
}
