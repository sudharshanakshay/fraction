import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/user.database.dart';

class UserServices extends ApplicationState {
  late UserDatabase _userDatabaseRef;

  UserServices() {
    _userDatabaseRef = UserDatabase();
  }

  Stream groupStream() {
    try {
      return _userDatabaseRef.userSubscribedGroupsStream(
          currentUserEmail: super.currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<void> createUserProfile({required preferedColor}) async {
    try {
      _userDatabaseRef.createUser(
          currentUserEmail: super.currentUserEmail,
          currentUserName: super.currentUserName,
          preferedColor: preferedColor);
    } catch (e) {
      // To-Do
      // display error to UI
    }
  }

  Future<String> getOneGroupName() {
    try {
      return _userDatabaseRef.getOneUserGroupName(
          currentUserEmail: super.currentUserEmail);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.value('');
    }
  }
}
