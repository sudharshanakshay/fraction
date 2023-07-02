// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/profile.dart';

// void createGroup(groupName) async {
//   await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
//     FirebaseFirestore.instance
//     .collection('profile')
//     .doc(profile.currentUserEmail)
//     .set(data)
//   });
// }

void getCloudGroupNames() async {
  bool kDebugMode = true;

  final cloudProfile =
      await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      final docMap = doc.data() as Map<String, dynamic>;
      final cloudGroupNames = docMap['groupNames'];
      return cloudGroupNames;
    }, onError: (e) => print("Error getting the data"));
  });

  if (kDebugMode) {
    print('-------- geting group Ids from cloud --------');
    print('Debug: $cloudProfile');
  }
}

Future updateCloudGroupNames(groupNameToAdd) async {
  bool kDebugMode = true;

  await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      final currentProfile = doc.data() as Map<String, dynamic>;
      List groupNames = currentProfile['groupNames'];

      for (var groupNameFromList in groupNames) {
        if (groupNameFromList == groupNameToAdd) {
          throw 'email already Exists!';
        }
      }
      groupNames.add(groupNameToAdd);

      final data = {'groupNames': groupNames};

      FirebaseFirestore.instance
          .collection('profile')
          .doc(profile.currentUserEmail)
          .set(data, SetOptions(merge: true))
          .whenComplete(() {
        if (kDebugMode) {
          print(
              '-------- groupName $groupNameToAdd added successfuly --------');
        }
      });
    });
  });
}
