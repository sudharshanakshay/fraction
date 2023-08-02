import 'package:fraction/app_state.dart';
import 'package:fraction/database/user.database.dart';

class UserServices extends ApplicationState {
  late UserDatabase database;

  UserServices() {
    database = UserDatabase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream groupStream() {
    try {
      return database.userSubscribedGroupsStream(
          currentUserEmail: super.currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<void> createUserProfile({required preferedColor}) async {
    try {
      database.createUser(
          currentUserEmail: super.currentUserEmail,
          currentUserName: super.currentUserName,
          preferedColor: preferedColor);
    } catch (e) {
      // To-Do
      // display error to UI
    }
  }
}
