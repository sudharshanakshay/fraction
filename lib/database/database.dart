import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/profile.dart';

class ProfileDatabase {
  void main() async {
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

    Future<void> insertProfile(Profile profile) async {
      final db = await database;
      await db.insert(
        'profile',
        profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<Profile> getProfileDetails() async {
      final db = await database;

      final List<Map<String, dynamic>> map = await db.query('profile');

      return Profile(
          currentUserName: map[0]['currentUserName'],
          currentUserEmail: map[0]['currentUserEmail']);
    }
  }
}
