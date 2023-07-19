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

Stream getGroupNames({required currentUserEamil}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEamil)
      .snapshots()
      .asyncExpand((DocumentSnapshot doc) {
    final profileInfo = doc.data()! as Map<String, dynamic>;
    return Stream.value(profileInfo['groupNames']);
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

Stream<Map<String, dynamic>> getProfileDetailsFromCloud(
    {required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .then(
    (DocumentSnapshot doc) {
      final data = doc.data()! as Map<String, dynamic>;
      return data;
    },
    onError: (e) => print("Error getting document: $e"),
  ).asStream();
}
