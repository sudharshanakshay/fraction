import 'package:fraction/database/notification.database.dart';

class NotificationService {
  late NotificationDatabase _notificationDatabaseRef;

  NotificationService() {
    _notificationDatabaseRef = NotificationDatabase();
  }

  Stream getNotiifcations({required String currentUserEmail}) {
    // super.refreshCurrentUserEmail().then((_) => print(super.currentUserEmail));
    // final prefs = await SharedPreferences.getInstance();
    // print(super.currentUserEmail);
    try {
      return _notificationDatabaseRef.getNotiifcations(
          currentUserEmail: currentUserEmail);
    } catch (e) {
      print(e);
      return const Stream.empty();
    }
  }

  dismissNotification() async {}
}
