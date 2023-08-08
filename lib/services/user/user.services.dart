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
}
