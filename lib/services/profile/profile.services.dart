import 'package:fraction/app_state.dart';
import 'package:fraction/database/profile.database.dart';

class ProfileServices extends ApplicationState {
  Stream myGroupsStream() {
    try {
      return ProfileDatabase().availableProfileGroupsStream(
          currentUserEmail: super.currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<void> createUserProfile({required preferedColor}) async {
    try {
      ProfileDatabase().createUserProfile(
          currentUserEmail: super.currentUserEmail,
          currentUserName: super.currentUserName,
          preferedColor: preferedColor);
    } catch (e) {
      // To-Do
      // display error to UI
    }
  }
}
