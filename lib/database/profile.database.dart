import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDatabase {
  Stream availableProfileGroupsStream({required currentUserEamil}) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEamil)
        .snapshots()
        .asyncExpand((DocumentSnapshot doc) {
      final profileInfo = doc.data()! as Map<String, dynamic>;
      return Stream.value(profileInfo['groupNames']);
    });
  }
}

// Stream availableProfileGroupsStream1({required currentUserEamil}) {
//   print(currentUserEamil);
//   return FirebaseFirestore.instance
//       .collection('profile')
//       .doc(currentUserEamil)
//       .snapshots()
//       .asyncExpand((DocumentSnapshot doc) {
//     print('hello1');
//     print(doc.data());
//     final profileInfo = doc.data()! as Map<String, dynamic>;
//     print('hello');
//     print('---$profileInfo---');
//     // return Stream.value(profileInfo['groupNames']);
//     return profileInfo['groupNames'];
//   }).asBroadcastStream();
// }
