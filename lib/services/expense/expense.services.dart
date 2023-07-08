import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/group.database.dart';

void deleteExpense(docId) {
  FirebaseFirestore.instance.collection('expense').doc(docId).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
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

// Future updateExpenseToGroupEntries(
//     {required currentUserEmail, required valueChange}) {
//   return FirebaseFirestore.instance
//       .collection('group')
//       .doc('akshaya')
//       .update({
//         'groupMembers ' : FieldValue.arrayRemove()
//       })
//       .get()
//       .then(
//     (DocumentSnapshot doc) {
//       if (doc.exists) {
//         final data = doc.data()! as Map<String, dynamic>;
//         print('---- printing data ----');
//         print(data);
//         for (var memberDetailObj in data['groupMembers']) {
//           if (memberDetailObj['userEmail'] == currentUserEmail) {
//             final previousExpense = memberDetailObj['totalExpense'];
//             final currentExpense = previousExpense + valueChange;
//             return currentExpense;
//           }
//         }
//         return data;
//       } else {
//         print('---- doc.exists is false ----');
//         return [];
//       }
//     },
//     onError: (e) => print("Error getting document: $e"),
//   );
//   // .then((currentExpense) {
//   //   final data = {
//   //     'groupMembers': [
//   //       {},
//   //     ]
//   //   };
//   // FirebaseFirestore.instance.collection('group')
//   // .doc('akshaya')
//   // });
// }

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

// donot add stream.empty()
Stream<QuerySnapshot> getExpenseCollectionFromCloud() {
  return FirebaseFirestore.instance
      .collection('expense')
      .where('groupName', isEqualTo: 'akshaya')
      // .where('emailAddress', whereIn: [])
      .where('emailAddress', whereIn: [
        'harshith8mangalore@gmail.com',
        'sudharshan6acharya@gmail.com'
      ])
      .orderBy('timeStamp', descending: true)
      .snapshots();
}
