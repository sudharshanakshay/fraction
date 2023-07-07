import 'package:cloud_firestore/cloud_firestore.dart';

void deleteExpense(docId) {
  FirebaseFirestore.instance.collection('expense').doc(docId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}

Stream<DocumentSnapshot> getGroupAccountDetails({required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('group')
      .doc('akshaya')
      .snapshots();
}

Stream<QuerySnapshot> getCurrentUserExpenseCollection(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('expense')
      .where('groupName', isEqualTo: 'akshaya')
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
      'groupName': 'akshaya',
      'timeStamp': DateTime.now()
    }).onError((error, stackTrace) {
      throw error!;
    });
    // .whenComplete(() {
    //   FirebaseFirestore.instance.collection('group')
    //   .doc('akshaya')
    //   // .update()
    // });
  });
}

Stream<QuerySnapshot> getExpenseCollectionFromCloud() {
  try {
    return FirebaseFirestore.instance
        .collection('group')
        .doc('akshaya')
        // .withConverter(
        //     fromFirestore: (snapShot, _) => GroupModel.fromJson(snapShot.data()!),
        //     toFirestore: (groupModel, _) => groupModel.toMemberEmails())
        .snapshots()
        .asyncExpand((doc) {
      // final listOfMemberAccount = doc.data();

      // final groupMembers = doc.data()?.toList();

      // GroupModel groupModel = GroupModel(
      //     groupMembers: doc.data()?['groupMembers'],
      //     groupName: doc.data()?['groupName']);

      List groupMemberEmailList = [];
      for (var groupMemberObj in doc.data()?['groupMembers']) {
        groupMemberEmailList.add(groupMemberObj['userEmail']);
      }

      print(groupMemberEmailList);

      return FirebaseFirestore.instance
          .collection('expense')
          .where('groupName', isEqualTo: 'akshaya')
          .where('emailAddress', whereIn: groupMemberEmailList)
          // .where('emailAddress', whereIn: [
          //   'harshith8mangalore@gmail.com',
          //   'sudharshan6acharya@gmail.com'
          // ])
          .orderBy('timeStamp', descending: true)
          .snapshots();
    });
  } catch (e) {
    print(e);
    return const Stream.empty();
  }
}
