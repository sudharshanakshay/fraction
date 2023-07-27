import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  String _currentUserName = '';
  String get currentUserName => _currentUserName;

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;

  String _currentUserGroup = '';
  String get currentUserGroup => _currentUserGroup;

  // ------------- Firebase Initailization -------------

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      // final prefs = await SharedPreferences.getInstance();
      if (user != null) {
        _loggedIn = true;
        _currentUserEmail = user.email!;
        // if (prefs.getString('currentUserGroup') == null) {
        if (_currentUserGroup.isEmpty) {
          try {
            FirebaseFirestore.instance
                .collection('profile')
                .doc(_currentUserEmail)
                .get()
                .then((DocumentSnapshot doc) async {
              final currentProfileDetails = doc.data() as Map<String, dynamic>;
              _currentUserName = currentProfileDetails['userName'];
              for (String groupName in currentProfileDetails['groupNames']) {
                if (groupName.isNotEmpty) {
                  print('---- printing group name from fraction services ----');
                  print(groupName);
                  _currentUserGroup = groupName;
                  notifyListeners();
                  // await prefs
                  //     .setString('currentUserGroup', _currentUserGroup)
                  //     .whenComplete(() {
                  //   notifyListeners();
                  // });

                  break;
                }
              }
            });
          } catch (e) {
            throw ('user has no group');
          }
        } else {
          // _currentUserGroup = prefs.getString('currentUserGroup')!;
          print('current group is $_currentUserGroup');
          notifyListeners();
        }
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  // ---- set currentUserGroup variable ----
  Future<void> setcurrentUserGroup({required String currentUserGroup}) async {
    _currentUserGroup = currentUserGroup;
    notifyListeners();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs
    //     .setString('currentUserGroup', currentUserGroup)
    //     .whenComplete(() {
    //   notifyListeners();
    // });

    print('current group -> $_currentUserGroup');
  }
}


// Future<void> init() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);

//     FirebaseUIAuth.configureProviders([
//       EmailAuthProvider(),
//     ]);

//     FirebaseAuth.instance.userChanges().listen((user) async {
//       final prefs = await SharedPreferences.getInstance();
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