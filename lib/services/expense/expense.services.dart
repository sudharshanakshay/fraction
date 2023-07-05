import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/profile.dart';

void addExpenseToCloud(
    {required String description, required String cost}) async {
  await getProfileDetailsFromLocalDatabase().then((ProfileModel profileModel) {
    FirebaseFirestore.instance.collection('expense').add(<String, dynamic>{
      'description': description,
      'cost': cost,
      'emailAddress': profileModel.currentUserEmail,
      'groupName': 'akshaya',
      'timeStamp': DateTime.now()
    });
  });
}
