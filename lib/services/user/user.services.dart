import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/user.database.dart';

class UserServices {
  late UserDatabase _userDatabaseRef;

  UserServices() {
    _userDatabaseRef = UserDatabase();
  }

  Stream groupStream({required String currentUserEmail}) {
    try {
      return _userDatabaseRef.userSubscribedGroupsStream(
          currentUserEmail: currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<void> createUserProfile(
      {required String currentUserName,
      required String currentUserEmail,
      required preferedColor}) async {
    try {
      _userDatabaseRef.createUser(
          currentUserEmail: currentUserEmail,
          currentUserName: currentUserName,
          preferedColor: preferedColor);
    } catch (e) {
      // To-Do
      // display error to UI
    }
  }

  Future<void> exitGroup(
      {required String currentUserEmail,
      required String currentUserGroup,
      required ApplicationState appState}) async {
    try {
      _userDatabaseRef
          .exitGroup(
              currentUserEmail: currentUserEmail,
              currentUserGroup: currentUserGroup)
          .whenComplete(() => appState.initCurrentUserGroup(bypassState: true));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
