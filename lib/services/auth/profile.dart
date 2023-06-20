import 'package:cloud_firestore/cloud_firestore.dart';

void addProfile(name, email, color) {
  FirebaseFirestore.instance.collection('profile').add(<String, dynamic>{
    'name': name,
    'email': email,
    'color_code': color,
    'group_id': []
  });
}
