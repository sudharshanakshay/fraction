import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void createUserProfile(name, email, color) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .set(<String, dynamic>{'name': name, 'color': color});
}

void createGroup(groupName) async {
  await SharedPreferences.getInstance().then((prefs) {
    print(prefs.getString('currentUserEmail'));
  });
  // final currentUserEmail = prefs.getString('currentUserEmail');

  // print('Current Email: $currentUserEmail');
  // FirebaseFirestore.instance
  //     .collection('profile')
  //     .doc(currentUserEmail)
  //     .collection('group')
  //     .doc(groupName)
  //     .set({
  //   'email_ids': ['email@domain'],
  // });

  // .whenComplete(
  //         () => updateGroupIds('mario@gmail.com', 'harshith@gmail.com'));
}

Future getCurrentUserProfile(email) async {
  bool kDebugMode = true;

  return FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .get()
      .then((DocumentSnapshot doc) {
    final data = doc.data();
    if (kDebugMode) {
      print('debug: $data');
    }
    if (data != null) {
      return data;
    } else {
      return null;
    }
  });
}

Future updateGroupIds(currentUserEmail, emailToAdd) async {
  bool kDebugMode = true;

  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .get()
      .then((DocumentSnapshot doc) {
    final currentProfile = doc.data() as Map<String, dynamic>;
    List emailIds = currentProfile['email_ids'];

    for (var emailFromList in emailIds) {
      if (emailFromList == emailToAdd) {
        throw 'email already Exists!';
      }
    }
    emailIds.add(emailToAdd);

    final data = {'email_ids': emailIds};

    FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEmail)
        .set(data, SetOptions(merge: true));
  });
}
