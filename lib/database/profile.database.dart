import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/profile.dart';

Future<void> insertProfile(ProfileModel profile) async {
  const bool kDebugMode = true;

  try {
    final database = openDatabase(
      join(await getDatabasesPath(), 'profile'),
      onCreate: (db, version) {
        return db.execute('''  
            CREATE TABLE IF NOT EXISTS profile(
              currentUserName TEXT,
              currentUserEmail TEXT
            )
        ''');
      },
      version: 1,
    );

    final db = await database;
    await db
        .insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .whenComplete(() {
      db.close();
      if (kDebugMode) {
        print('-------- insert successful --------');
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('-------- error inserting profile --------');
      print('-------- $e --------');
    }
  }
}

Future<ProfileModel> getProfileDetailsFromLocalDatabase() async {
  const bool kDebugMode = true;
  try {
    final database = openDatabase(
      join(await getDatabasesPath(), 'profile'),
      onCreate: (db, version) {
        return db.execute('''  
            CREATE TABLE IF NOT EXISTS profile(
              currentUserName TEXT,
              currentUserEmail TEXT
            )
        ''');
      },
      version: 1,
    );
    final db = await database;

    final List<Map<String, dynamic>> map =
        await db.query('profile').whenComplete(() => db.close());

    return ProfileModel(
        currentUserName: map[0]['currentUserName'],
        currentUserEmail: map[0]['currentUserEmail']);
  } catch (e) {
    if (kDebugMode) {
      print('-------- error inserting profile --------');
      print('-------- $e --------');
    }
  }

  return ProfileModel(
      currentUserName: "currentUserName", currentUserEmail: "currentUserEmail");
}
