import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseDatabase {
  final _expenseCollectionName = 'expense';

  Stream<QuerySnapshot> getExpenseCollection({required currentGroupName}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection(_expenseCollectionName)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .handleError((e) {
      throw (e);
    });
  }

  Future<void> addExpense(
      {required currentGroupName,
      required currentUserName,
      required currentUserEmail,
      required String description,
      required cost}) {
    final data = {
      'description': description,
      'cost': cost,
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'timeStamp': DateTime.now()
    };
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .doc()
        .set(data);
  }

  Stream<QuerySnapshot> getMyExpenses(
      {required currentGroupName, required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .where('emailAddress', isEqualTo: currentUserEmail)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future deleteMyExpense(
      {required currentUserEmail,
      required currentGroupName,
      required docId}) async {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .doc(docId)
        .delete()
        .then(
      (doc) {
        print("Document deleted");
      },
      onError: (e) => print("Error updating document $e"),
    );
  }

  // getExpenseAndAddToSubCollectionInGroup() {
  //   FirebaseFirestore.instance.collection('expense').get().then((value) {
  //     if (value.docs.isNotEmpty) {
  //       for (var element in value.docs) {
  //         print(element.data());
  //         FirebaseFirestore.instance
  //             .collection('group')
  //             .doc('akshaya')
  //             .collection('expense')
  //             .doc()
  //             .set(element.data());
  //       }
  //     }
  //   });
  // }
}
