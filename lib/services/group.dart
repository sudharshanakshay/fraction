import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth/profile.dart';

void createGroup(groupName, admin){
  FirebaseFirestore.instance.collection('group').add({
    'name':groupName,
    'group_id':'gen_group_id',
    'admin': admin,
    'email_ids': [],
  }).whenComplete(() => updateGroupIds('mario@gmail.com', 'ntonot@gmail.com' ));
}