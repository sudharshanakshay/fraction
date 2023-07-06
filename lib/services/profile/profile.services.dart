import 'package:cloud_firestore/cloud_firestore.dart';

void createUserProfile(
    {required userName, required currentUserEmail, required color}) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .set(<String, dynamic>{
    'userName': userName,
    'emailAddress': currentUserEmail,
    'color': color,
    'groupNames': []
  });
}

Stream getGroupNamesFromProfile(currentUserEmail,
    {currentGroupName = 'akshaya'}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .snapshots()
      .asyncExpand((doc) {
    for (var groupName in doc.data()?['groupNames']) {
      if (groupName == currentGroupName) return Stream.value(groupName);
    }
    return const Stream.empty();
  });
}

Stream<DocumentSnapshot> getProfileDetailsFromCloud(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .asStream();
}
