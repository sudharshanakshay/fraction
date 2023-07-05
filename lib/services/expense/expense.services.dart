import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/group.dart';
import 'package:fraction/model/profile.dart';

Future addExpenseToCloud({required String description, required cost}) async {
  await getProfileDetailsFromLocalDatabase().then((ProfileModel profileModel) {
    return FirebaseFirestore.instance
        .collection('expense')
        .add(<String, dynamic>{
      'description': description,
      'cost': cost,
      'emailAddress': profileModel.currentUserEmail,
      'groupName': 'akshaya',
      'timeStamp': DateTime.now()
    }).onError((error, stackTrace) {
      throw error!;
    });
  });
}

Stream<QuerySnapshot> getExpenseCollectionFromCloud() {
  return FirebaseFirestore.instance
      .collection('group')
      .doc('akshaya')
      .withConverter(
          fromFirestore: (snapShot, _) => GroupModel.fromJson(snapShot.data()!),
          toFirestore: (groupModel, _) => groupModel.toJson())
      .snapshots()
      .asyncExpand((doc) {
    final groupMembers = doc.data()?.toList();

    return FirebaseFirestore.instance
        .collection('expense')
        .where('groupName', isEqualTo: 'akshaya')
        .where('emailAddress', whereIn: groupMembers)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  });
}
