import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fraction/database/user.database.dart';
import 'package:fraction/database/utils/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  late FirebaseFirestore firebaseFirestoreRef;
  late String _userCollectionName;
  late String _groupCollectionName;

  ApplicationState() {
    firebaseFirestoreRef = FirebaseFirestore.instance;
    _userCollectionName = DatabaseUtils().userCollectionName;
    _groupCollectionName = DatabaseUtils().groupCollectionName;
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _hasOneGroup = true;
  bool get hasOneGroup => _hasOneGroup;
  set hasOneGroup(bool value) => _hasOneGroup = value;

  String _currentUserName = '';
  String get currentUserName => _currentUserName;

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;

  String _currentUserGroup = '';
  String get currentUserGroup => _currentUserGroup;

  final Map<String, Timestamp> _groupsAndExpenseInstances = {};
  Map<String, Timestamp> get groupAndExpenseInstances =>
      _groupsAndExpenseInstances;

  // Timestamp _currentExpenseInstance;
  Timestamp get currentExpenseInstance =>
      _groupsAndExpenseInstances[_currentUserGroup]!;

  // ------------- Firebase Initailization -------------

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _currentUserEmail = user.email!;
        await initGroupAndExpenseInstances();
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<void> initGroupAndExpenseInstances() async {
    await setGroupAndExpenseInstances().whenComplete(() async {
      await setCurrentUserGroup();
    });
  }

  // ---- set currentUserGroup ----
  Future<void> setCurrentUserGroup() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUserGroup.isEmpty) {
      if (prefs.getString('currentUserGroup') == null) {
        if (_currentUserEmail.isNotEmpty) {
          String groupNameFromUserProfile = await UserDatabase()
              .getOneUserGroupName(currentUserEmail: _currentUserEmail);
          prefs.setString('currentUserGroup', groupNameFromUserProfile);
          _currentUserGroup = groupNameFromUserProfile;
          notifyListeners();
        }
      } else {
        _currentUserGroup = prefs.getString('currentUserGroup') ?? '';
        notifyListeners();
      }
    }
  }

  Future<void> setGroupAndExpenseInstances() async {
    // -- get values from user database ----
    firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(_currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.exists) {
        final currentProfileDetails = doc.data() as Map<String, dynamic>;
        // ---- set current user name from user database ----
        _currentUserName = currentProfileDetails['userName'];
        notifyListeners();

        if (currentProfileDetails['groupNames'].length != 0) {
          _hasOneGroup = true;
          for (String groupName in currentProfileDetails['groupNames']) {
            // ---- get values from group database ----

            firebaseFirestoreRef
                .collection(_groupCollectionName)
                .doc(groupName)
                .get()
                .then((doc) {
              final value = doc.data()!['expenseInstance'];
              Map<String, Timestamp> data = {groupName: value};

              // ---- set the group name & instance value from the groups database ----
              _groupsAndExpenseInstances.addAll(data);
              // print('group added');
            }).whenComplete(() {
              notifyListeners();
              // print('notified');
            });
          }
        } else {
          _hasOneGroup = false;
          notifyListeners();
        }
      }
    });
  }

  printGroupMap() {
    _groupsAndExpenseInstances.forEach((key, value) {
      print('key : $key -- value: ${value.toDate()}');
    });
  }

  // ---- set currentUserGroup variable ----
  Future<void> setcurrentUserGroup({required String currentUserGroup}) async {
    final prefs = await SharedPreferences.getInstance();

    _currentUserGroup = currentUserGroup;
    notifyListeners();

    await prefs.setString('currentUserGroup', currentUserGroup);
  }

  // ------------- option, sign-out -------------

  void signOut() async {
    FirebaseAuth.instance.signOut();
    // await clearProfileDetailsFromLocalStorage()
    //     .whenComplete(() => FirebaseAuth.instance.signOut());
  }
}
