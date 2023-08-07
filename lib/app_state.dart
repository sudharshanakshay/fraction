import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/database/utils/database.dart';
import 'package:fraction/services/user/user.services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  final String _currentUserGroupName = 'currentUserGroupName';

  late FirebaseFirestore _firebaseFirestoreRef;
  late String _userCollectionName;
  late String _groupCollectionName;

  // static final Map<String, ApplicationState> _cache =
  //     <String, ApplicationState>{};

  ApplicationState() {
    _firebaseFirestoreRef = FirebaseFirestore.instance;
    _userCollectionName = DatabaseUtils().userCollectionName;
    _groupCollectionName = DatabaseUtils().groupCollectionName;
    init();
    refreshCurrentUserEmail();
  }

  // ApplicationState._internal({required String name}) {}

  // factory ApplicationState() {
  //   return _cache['appState']!;
  // }

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
      final prefs = await SharedPreferences.getInstance();
      if (user != null) {
        _loggedIn = true;
        _currentUserEmail = user.email!;
        prefs.setString('currentUserEmail', user.email!);
        await initGroupAndExpenseInstances();
      } else {
        _loggedIn = false;
      }
      notifyListeners();
      // await setCurrentUserName();
    });
  }

  // Future<void> setCurrentUserName() async {
  //   if (_currentUserName.isEmpty && _currentUserEmail.isNotEmpty) {
  //     final prefs = await SharedPreferences.getInstance();

  //     // _currentUserName = prefs.getString('currentUserName') ??
  //     _userCollectionRef.doc(_currentUserEmail).get().then((value) {
  //       print(value.data()!['userName']);
  //     });
  //   }
  // }

  Future<void> refreshCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUserEmail.isEmpty) {
      if (prefs.getString('currentUserEmail') != null) {
        _currentUserEmail = prefs.getString('currentUserEmail') ?? '';
        notifyListeners();
      }
    }
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
      _currentUserGroup = prefs.getString(_currentUserGroupName) ??
          await UserServices().getOneGroupName().then((String value) {
            prefs.setString(_currentUserGroupName, value);
            return value;
          });

      notifyListeners();
      if (kDebugMode) {
        print(_currentUserGroup);
      }
    }
  }

  Future<void> setGroupAndExpenseInstances() async {
    // -- get values from user database ----
    _firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(_currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.exists) {
        final currentProfileDetails = doc.data() as Map<String, dynamic>;
        // ---- set current user name from user database ----
        _currentUserName = currentProfileDetails['userName'];
        notifyListeners();

        final groupList = currentProfileDetails['groupNames'] as List;
        if (groupList.isNotEmpty) {
          _hasOneGroup = true;
          for (String groupName in groupList) {
            // ---- get values from group database ----

            _firebaseFirestoreRef
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

    await prefs.setString(_currentUserGroupName, currentUserGroup);
  }

  // ------------- option, sign-out -------------

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('currentUserEmail');
    // await prefs.remove(_currentUserGroupName);
    // await prefs.remove('currentUserEmail');
    prefs.clear().then((value) {
      if (value) {
        FirebaseAuth.instance.signOut();
        if (kDebugMode) {
          print('---- prefs clear complete ----');
        }
      } else {
        if (kDebugMode) {
          print('---- error  clearing ----');
        }
      }
    });
  }
}
