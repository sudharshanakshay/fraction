import 'package:cloud_firestore/cloud_firestore.dart';

const _groupCollectionName = 'group';

// -- whenever user creates group, user is added to that group by default --
Future<String> createGroup(
    {required groupName, required adminName, required adminEmail}) {
  final adminEmailR = adminEmail.replaceAll('.', '#');
  final data = {
    'groupName': groupName,
    'groupMembers': {
      adminEmailR: {
        'memberName': adminName,
        'memberEmail': adminEmail,
        'totalExpense': 0
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

// -- get group collecton --
Stream<QuerySnapshot> getGroupCollection() {
  return FirebaseFirestore.instance
      .collection(_groupCollectionName)
      .snapshots();
}

// -- add member to the group requires, groupName to add & member details --
Future<void> addMemberToGroup(
    {required String currentGroupName,
    required String memberName,
    required String memberEmail}) {
  final memberEmailR = memberEmail.replaceAll('.', '#');
  final data = {
    'memberName': memberName,
    'memberEmail': memberEmail,
    'totalExpense': 0
  };
  return FirebaseFirestore.instance
      .collection(_groupCollectionName)
      .doc(currentGroupName)
      .update({"groupMembers.$memberEmailR": data});
}

// -- retrive group details --
Stream<DocumentSnapshot> getGroupDetails({required groupName}) {
  return FirebaseFirestore.instance
      .collection(_groupCollectionName)
      .doc(groupName)
      .snapshots();
}

// -- update group member details, expenseDiff can be '+' representing addition to current value, '-' vise-versa --
void updateGroupMemberDetails(
    {required groupName, required memberEmail, required int expenseDiff}) {
  final memberEmailR = memberEmail.replaceAll('.', '#');
  final data = {
    'groupMembers.$memberEmailR.totalExpense': FieldValue.increment(expenseDiff)
  };
  FirebaseFirestore.instance
      .collection(_groupCollectionName)
      .doc(groupName)
      .update(data);
}

// -- retrive all group members --
Future getGroupMembers({required groupName}) {
  return FirebaseFirestore.instance
      .collection(_groupCollectionName)
      .doc(groupName)
      .get()
      .then((DocumentSnapshot doc) {
    if (doc.exists) {
      List groupMembers = [];
      final data = doc.data()! as Map<String, dynamic>;
      for (var memberEmail in data['groupMembers']) {
        print(memberEmail['userEmail']);
        groupMembers.add(memberEmail['userEmail']);
      }
      return groupMembers;
    } else {
      throw 'no group member exists';
    }
  });
}
