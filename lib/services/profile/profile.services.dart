import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fraction/database/profile.database.dart';

class ProfileServices extends ChangeNotifier {
  ProfileServices() {
    init();
  }
  String? _currentUserEmail;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        _currentUserEmail = user.email!;
        // return _currentUserEmail;
        print(_currentUserEmail);
        notifyListeners();
      }
    });
  }
}

String? _currentUserEmail;

Future<void> init() async {
  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      _currentUserEmail = user.email!;
      // return _currentUserEmail;
    }
  });
}

Stream availableProfileGroupsStream({required String currentUserEmail}) {
  return ProfileDatabase()
      .availableProfileGroupsStream(currentUserEamil: currentUserEmail);
}

Future getOneProfileGroupName({required String currentUserEmail}) {
  return ProfileDatabase()
      .getOneProfileGroupName(currentUserEmail: currentUserEmail);
}

void createUserProfile(
    {required userName, required currentUserEmail, required color}) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .set(<String, dynamic>{
    'userName': userName,
    'emailAddress': currentUserEmail,
    'color': color,
    'groupNames': []
  });
}

// Stream availableProfileGroupsStream() {
//   return FirebaseFirestore.instance
//       .collection('profile')
//       .doc(_currentUserEmail)
//       .snapshots()
//       .asyncExpand((DocumentSnapshot doc) {
//     final profileInfo = doc.data()! as Map<String, dynamic>;
//     return Stream.value(profileInfo['groupNames']);
//   });
// }

Stream getGroupNamesFromProfile(currentUserEmail,
    {currentGroupName = 'akshaya'}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .snapshots()
      .asyncExpand((doc) {
    for (var groupName in doc.data()?['groupNames']) {
      if (groupName == currentGroupName) return Stream.value(groupName);
    }
    return const Stream.empty();
  });
}

Stream<Map<String, dynamic>> getProfileDetailsFromCloud(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .then(
    (DocumentSnapshot doc) {
      final data = doc.data()! as Map<String, dynamic>;
      return data;
    },
    onError: (e) => print("Error getting document: $e"),
  ).asStream();
}
