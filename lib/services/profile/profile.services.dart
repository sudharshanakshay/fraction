import 'package:cloud_firestore/cloud_firestore.dart';

void createUserProfile(name, email, color) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .set(<String, dynamic>{'name': name, 'color': color, 'groupNames': []});
}

Future getProfileDetailFromCloud(email) async {
  bool kDebugMode = true;

  return FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .get()
      .then((DocumentSnapshot doc) {
    final data = doc.data();
    if (kDebugMode) {
      print('debug: $data');
    }
    if (data != null) {
      return data;
    } else {
      return null;
    }
  });
}
