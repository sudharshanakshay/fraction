import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fraction/database/group.database.dart';
import '../../model/group.dart';

const _currentGroupName = 'akshaya';
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

void deleteExpense({required docId, required cost}) {
  init().whenComplete(() {
    FirebaseFirestore.instance.collection('expense').doc(docId).delete().then(
      (doc) {
        print("Document deleted");
      },
      onError: (e) => print("Error updating document $e"),
    ).whenComplete(() {
      updateGroupMemberDetails(
          groupName: _currentGroupName,
          memberEmail: _currentUserEmail,
          expenseDiff: -int.parse(cost));
    });
  });
}

Stream<QuerySnapshot> getCurrentUserExpenseCollection(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('expense')
      .where('groupName', isEqualTo: _currentGroupName)
      .where('emailAddress', whereIn: [currentUserEmail])
      .orderBy('timeStamp', descending: true)
      .snapshots();
}

Future addExpenseToCloud(
    {required currentUserEmail,
    required String description,
    required cost}) async {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .then((doc) {
    FirebaseFirestore.instance.collection('expense').add(<String, dynamic>{
      'description': description,
      'cost': cost,
      'userName': doc.data()?['userName'],
      'emailAddress': doc.data()?['emailAddress'],
      'groupName': _currentGroupName,
      'timeStamp': DateTime.now()
    }).onError((error, stackTrace) {
      throw error!;
    }).whenComplete(() {
      updateGroupMemberDetails(
        memberEmail: currentUserEmail,
        groupName: _currentGroupName,
        expenseDiff: int.parse(cost),
      );
    });
  });
}

// donot add stream.empty()
Stream<QuerySnapshot> getExpenseCollectionFromCloud() {
  return FirebaseFirestore.instance
      .collection('group')
      .doc(_currentGroupName)
      .withConverter<GroupModel>(
          fromFirestore: (snapShot, _) => GroupModel.fromJson(snapShot.data()!),
          toFirestore: (groupModel, _) => groupModel.toJson())
      .snapshots()
      .asyncExpand((doc) {
    List? memberEmailList = doc.data()?.toMemberEmailsList();
    return FirebaseFirestore.instance
        .collection('expense')
        .where('groupName', isEqualTo: _currentGroupName)
        .where('emailAddress', whereIn: memberEmailList)
        // .where('emailAddress', whereIn: [
        //   'harshith8mangalore@gmail.com',
        //   'sudharshan6acharya@gmail.com'
        // ])
        .orderBy('timeStamp', descending: true)
        .snapshots();
  });
}
