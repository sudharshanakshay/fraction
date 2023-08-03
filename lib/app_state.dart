import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  // late FirebaseFirestoreRef;
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _hasGroup = true;
  bool get hasGroup => _hasGroup;
  set hasGroup(bool value) => _hasGroup = value;

  String _currentUserName = '';
  String get currentUserName => _currentUserName;

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;

  String _currentUserGroup = '';
  String get currentUserGroup => _currentUserGroup;

  // Timestamp _currentExpenseInstance;
  Timestamp? get currentExpenseInstance =>
      groupsAndExpenseInstances[_currentUserGroup];

  Map<String, Timestamp> groupsAndExpenseInstances = {};

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
            await setGroupAndExpenseInstances();
          } catch (e) {
            throw ('user has no group');
          }
          print(groupsAndExpenseInstances);
        } else {
          // _currentUserGroup = prefs.getString('currentUserGroup')!;
          notifyListeners();
        }
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> setGroupAndExpenseInstances() async {
    // -- get values from user database ----
    FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.exists) {
        final currentProfileDetails = doc.data() as Map<String, dynamic>;
        // ---- set current user name from user database ----
        _currentUserName = currentProfileDetails['userName'];

        for (String groupName in currentProfileDetails['groupNames']) {
          if (groupName.isNotEmpty) {
            // ---- get values from group database ----

            FirebaseFirestore.instance
                .collection('group')
                .doc(groupName)
                .get()
                .then((value) => value.data()!['expenseInstance'])
                .then((value) {
              // ---- set the group name & instance value from the groups database ----
              Map<String, Timestamp> data = {groupName: value};
              // print(data);
              groupsAndExpenseInstances.addAll(data);
            });
          }
        }
      }
    });
  }

  printGroupMap() {
    groupsAndExpenseInstances.forEach((key, value) {
      print('key : $key -- value: ${value.toDate()}');
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
  }

  // ------------- option, sign-out -------------

  void signOut() async {
    FirebaseAuth.instance.signOut();
    // await clearProfileDetailsFromLocalStorage()
    //     .whenComplete(() => FirebaseAuth.instance.signOut());
  }
}
