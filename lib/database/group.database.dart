import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/model/group.dart';

class GroupDatabase {
  final _groupCollectionName = 'group';
// -- group is created as follows, groupName%creatorEmail%timeStamp --
// -- '%' represents key separation & --
// -- '#' represents '.' in a key --
// -- whenever user creates group, user is added to that group by default --
  Future<String> createGroup(
      {required groupName,
      required adminName,
      required adminEmail,
      required nextClearOffTimeStamp}) {
    final adminEmailR = adminEmail.replaceAll('.', '#');
    final data = {
      'createdOn': DateTime.now(),
      'nextClearOffTimeStamp': nextClearOffTimeStamp,
      'groupName': groupName,
      'totalExpense': 0,
      'groupMembers': {
        adminEmailR: {
          'memberName': adminName,
          'memberEmail': adminEmail,
          'memberExpense': 0
        }
      }
    };

    final String groupNameWithIdentity = groupName +
        '%' +
        adminEmail +
        '%' +
        DateTime.now().toString().replaceAll(RegExp(r'[\s]'), '%');

    return FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupNameWithIdentity)
        .set(data)
        .then((value) => groupNameWithIdentity);
  }

  Stream getGroupDetials({required groupName}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(groupName)
        .snapshots();
  }

  Stream getMyExpense({required currentUserEmail, required groupName}) {
    final currentUserEmailR = currentUserEmail.replaceAll('.', '#');

    return FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupName)
        .snapshots()
        .asyncExpand((doc) {
      // print(doc.data()!['groupMembers'][currentUserEmailR]['totalExpense']);
      return Stream.value(
          doc.data()!['groupMembers'][currentUserEmailR]['totalExpense']);
    });
  }

  Future<List?> getMemberDetails({required currentUserGroup}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentUserGroup)
        .withConverter<GroupModel>(
            fromFirestore: (snapShot, _) =>
                GroupModel.fromJson(snapShot.data()!),
            toFirestore: (groupModel, _) => groupModel.toJson())
        .get()
        .then((doc) {
      // print('----------------------');
      // print(' Expense Account  ${doc.data()}');
      return doc.data()?.toList();
    });
  }

  // -- add member to the group requires, groupName to add & member details --
  Future<void> insertMemberToGroup(
      {required String currentGroupName,
      required String memberName,
      required String memberEmail}) {
    final memberEmailR = memberEmail.replaceAll('.', '#');
    final data = {
      'memberName': memberName,
      'memberEmail': memberEmail,
      'memberExpense': 0
    };
    return FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(currentGroupName)
        .update({"groupMembers.$memberEmailR": data});
  }

  // -- update group member details, expenseDiff can be '+' representing addition to current value, '-' vise-versa --
  void updateGroupMemberExpense(
      {required groupName, required memberEmail, required int expenseDiff}) {
    final memberEmailR = memberEmail.replaceAll('.', '#');
    final data = {
      'groupMembers.$memberEmailR.totalExpense':
          FieldValue.increment(expenseDiff)
    };
    FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupName)
        .update(data);
  }

  Future insertGroupNameToProfile(
      {required currentUserEmail, required groupNameToAdd}) async {
    bool kDebugMode = true;

    FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEmail)
        .update({
      "groupNames": FieldValue.arrayUnion([groupNameToAdd]),
    }).whenComplete(() {
      if (kDebugMode) {
        print('-------- groupName $groupNameToAdd added successfuly --------');
      }
    });
  }
}
