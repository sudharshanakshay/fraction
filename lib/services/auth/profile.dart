import 'package:cloud_firestore/cloud_firestore.dart';

void createUserProfile(name, email, color) {
  FirebaseFirestore.instance
      .collection('profile')
      .doc(email)
      .set(<String, dynamic>{
    'name': name,
    'email': email,
    'color_code': color,
    'group_id': []
  });
}

Future getCurrentUserProfile(email) async {

  bool kDebugMode = true;

  return FirebaseFirestore.instance.collection('profile').doc(email).get()
  .then(
    (DocumentSnapshot doc) {
      final data = doc.data();  
      if (kDebugMode) {
        print('debug: $data');
      }
      if(data!=null) return data; 
    });
}

Future updateGroupIds(currentUserEmail, email) async{

  final data = {
    'email_ids': [email,],
  };

  FirebaseFirestore.instance.collection('profile').doc(currentUserEmail).set(data, SetOptions(merge: true));
}
