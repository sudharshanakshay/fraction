import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

void updateTotalExpenseSubCollectionAccount(
    {required userEmail, required newCost}) {
  final accRef = FirebaseFirestore.instance
      .collection('group')
      .doc('akshaya')
      .collection('account')
      .doc(userEmail);
  accRef.get().then((doc) {
    final previousExpense = doc.data()?['totalExpense'];
    return previousExpense;
  }).then((previousExpense) {
    accRef.update({'totalExpense': previousExpense + newCost});
  });
}

Future<void> joinCloudGroup(
    {required inputGroupName, required currentUserEmail}) async {
  FirebaseFirestore.instance
      .collection('group')
      .where('groupName', isEqualTo: inputGroupName)
      .get()
      .then((querySnapshot) {
    print('Successfully completed');

    for (var docSnapshot in querySnapshot.docs) {
      print('${docSnapshot.id} => ${docSnapshot.data()}');
      if (docSnapshot.data()['groupName'] == inputGroupName) {
        updateGroupNameToProfileCollection(
            currentUserEmail: currentUserEmail, groupNameToAdd: inputGroupName);
        updateGroupMembersToGroupCollection(
          groupName: inputGroupName,
          currentUserEmail: currentUserEmail,
        );
      }
    }
  });
}

Future<void> createCloudGroup(
    {required inputGroupName, required currentUserEmail}) async {
  final data = {'groupName': inputGroupName, 'groupMembers': []};
  FirebaseFirestore.instance
      .collection('group')
      .doc(inputGroupName)
      .set(data)
      .whenComplete(() {
    updateGroupNameToProfileCollection(
        currentUserEmail: currentUserEmail, groupNameToAdd: inputGroupName);
    updateGroupMembersToGroupCollection(
      groupName: inputGroupName,
      currentUserEmail: currentUserEmail,
    );
  });
}

Future updateGroupMembersToGroupCollection(
    {required groupName, required currentUserEmail}) async {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .then((doc) {
    var data = {
      'userName': doc.data()?['userName'],
      'userEmail': doc.data()?['emailAddress'],
      'totalExpense': 0
    };

    FirebaseFirestore.instance.collection('group').doc(groupName).update({
      "groupMembers": FieldValue.arrayUnion([data]),
    });
  });
}

Future updateGroupNameToProfileCollection(
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
