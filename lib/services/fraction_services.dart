// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FractionServices extends ChangeNotifier {
//   // var prefs;
//   FractionServices() {
//     init();
//   }

//   bool _loggedIn = false;
//   bool get loggedIn => _loggedIn;

//   String _currentUserEmail = '';
//   String get currentUserEmail => _currentUserEmail;

//   String _currentUserGroup = '';
//   String get currentUserGroup => _currentUserGroup;

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();

//     FirebaseAuth.instance.userChanges().listen((user) async {
//       if (user != null) {
//         _loggedIn = true;
//         _currentUserEmail = user.email!;
//         if (prefs.getString('currentUserGroup') == null) {
//           try {
//             FirebaseFirestore.instance
//                 .collection('profile')
//                 .doc(_currentUserEmail)
//                 .get()
//                 .then((DocumentSnapshot doc) async {
//               final currentProfileDetails = doc.data() as Map<String, dynamic>;
//               for (String groupName in currentProfileDetails['groupNames']) {
//                 if (groupName.isNotEmpty) {
//                   print('---- printing group name from fraction services ----');
//                   print(groupName);
//                   _currentUserGroup = groupName;
//                   await prefs
//                       .setString('currentUserGroup', _currentUserGroup)
//                       .whenComplete(() {
//                     notifyListeners();
//                   });

//                   break;
//                 }
//               }
//             });
//           } catch (e) {
//             throw ('user has no group');
//           }
//         } else {
//           _currentUserGroup = prefs.getString('currentUserGroup')!;
//           print('current group is $_currentUserGroup');
//           notifyListeners();
//         }
//       } else {
//         _loggedIn = false;
//       }
//       notifyListeners();
//     });
//   }

//   // ---- set currentUserGroup variable ----
//   Future<void> setcurrentUserGroup({required String currentUserGroup}) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs
//         .setString('currentUserGroup', currentUserGroup)
//         .whenComplete(() {
//       _currentUserGroup = prefs.getString('currentUserGroup')!;
//       notifyListeners();
//     });

//     print('current group -> $_currentUserGroup');
//   }

//   // void setSharedPref({currentUserGroup}) async {
//   //   final pref = await SharedPreferences.getInstance();
//   //   await pref.setString('currentUserGroup', currentUserGroup);
//   // }
// }
