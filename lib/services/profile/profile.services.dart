import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getCurrentUserExpenseCollection(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('expense')
      .where('groupName', isEqualTo: 'akshaya')
      .where('emailAddress', whereIn: [currentUserEmail])
      .orderBy('timeStamp', descending: true)
      .snapshots();
}

void createUserProfile(name, email, color) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .set(<String, dynamic>{'name': name, 'color': color, 'groupNames': []});
}

Future getProfileDetailsFromCloud(email) async {
  bool kDebugMode = true;

  return FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .get()
      .then((DocumentSnapshot doc) {
    final data = doc.data();
    if (kDebugMode) {
      print('---- Debug:Cloud $data (profile.services) ----');
    }
    if (data != null) {
      return data;
    } else {
      return null;
    }
  });
}
