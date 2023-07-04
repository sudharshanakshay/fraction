import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/group.dart';
import 'package:fraction/model/profile.dart';

Future<GroupModel> getCloudGroupNames() async {
  bool kDebugMode = true;

  final groupNames = await getProfileDetailsFromLocalDatabase()
      .then((ProfileModel profile) async {
    print('---- check local: ${profile.currentUserEmail} ----');
    final groupModel = await FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        final docMap = doc.data() as Map<String, dynamic>;
        final cloudGroupNames = docMap['groupNames'];
        if (kDebugMode) {
          print('-------- geting group Ids from cloud --------');
          print('Debug:cloud $cloudGroupNames');
        }

        return cloudGroupNames;
        // return GroupModel(groupNames: cloudGroupNames);
      } else {
        if (kDebugMode) {
          print('---- data does not exists (group.services) ----');
        }
        return ['data dosnt exists'];
      }
    }, onError: (e) {
      print("Error getting the data");
      print(' ---- $e (group.services) ----');
    });

    print('---- checking before returning to group state ----');
    print('----Debug:cloud $groupModel ----');
    return groupModel;
  });

  print('---- checking before returning to group state ----');
  print('----Debug:cloud $groupNames ----');

  return GroupModel(groupNames: groupNames);
}

// Future<void> joinCloudGroup(inputGroupName) async {
//   FirebaseFirestore.instance
//       .collection('group')
//       .where('groupName', isEqualTo: inputGroupName)
//       .get()
//       .then((querySnapshot) {
//     print('Successfully completed');

//     for (var docSnapshot in querySnapshot.docs) {
//       print('${docSnapshot.id} => ${docSnapshot.data()}');
//       if (docSnapshot.data()['groupName'] == inputGroupName) {
//         updateGroupNameToProfileCollection(inputGroupName);
//         updateGroupMembersToGroupCollection(inputGroupName);
//       }
//     }
//   });
// }

Future<void> createCloudGroup(groupName) async {
  await getProfileDetailsFromLocalDatabase().then((ProfileModel profileModel) {
    final data = {'groupName': groupName, 'groupMembers': []};
    FirebaseFirestore.instance
        .collection('group')
        .doc(groupName)
        .set(data)
        .whenComplete(() {
      updateGroupNameToProfileCollection(groupName);
      updateGroupMembersToGroupCollection(groupName);
    });
  });
}

Future updateGroupMembersToGroupCollection(groupName) async {
  await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
    FirebaseFirestore.instance.collection('group').doc(groupName).update({
      "groupMembers": FieldValue.arrayUnion([profile.currentUserEmail]),
    });
  });
}

Future updateGroupNameToProfileCollection(groupNameToAdd) async {
  bool kDebugMode = true;

  await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.currentUserEmail)
        .update({
      "groupNames": FieldValue.arrayUnion([groupNameToAdd]),
    }).whenComplete(() {
      if (kDebugMode) {
        print('-------- groupName $groupNameToAdd added successfuly --------');
      }
    });
  });

  // await getProfileDetailsFromLocalDatabase().then((ProfileModel profile) {
  //   FirebaseFirestore.instance
  //       .collection('profile')
  //       .doc(profile.currentUserEmail)
  //       .get()
  //       .then((DocumentSnapshot doc) {
  //     final currentProfile = doc.data() as Map<String, dynamic>;
  //     List groupNames = currentProfile['groupNames'];

  //     for (var groupNameFromList in groupNames) {
  //       if (groupNameFromList == groupNameToAdd) {
  //         throw 'group already Exists!';
  //       }
  //     }
  //     groupNames.add(groupNameToAdd);

  //     final data = {'groupNames': groupNames};

  //     FirebaseFirestore.instance
  //         .collection('profile')
  //         .doc(profile.currentUserEmail)
  //         .set(data, SetOptions(merge: true))
  //         .whenComplete(() {
  //       if (kDebugMode) {
  //         print(
  //             '-------- groupName $groupNameToAdd added successfuly --------');
  //       }
  //     });
  //   });
  // });
}
