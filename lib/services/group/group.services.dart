// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/group.dart';
import 'package:fraction/model/profile.dart';

Future<GroupModel> getCloudGroupNames() async {
  bool kDebugMode = true;

  return await getProfileDetailsFromLocalDatabase()
      .then((ProfileModel profile) {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      final docMap = doc.data() as Map<String, dynamic>;
      final cloudGroupNames = docMap['groupNames'];
      if (kDebugMode) {
        print('-------- geting group Ids from cloud --------');
        print('Debug: $cloudGroupNames');
      }
      return GroupModel(groupName: cloudGroupNames);
    }, onError: (e) => print("Error getting the data"));
    return GroupModel(groupName: []);
  });
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
