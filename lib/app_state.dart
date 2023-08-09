import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/database/utils/database.dart';
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

        // ---- set current user group instances ----
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
                  if (doc.exists) {
                    if (kDebugMode) {
                      print(
                          '(app_state 1) : expense instance : ${doc.data()!['expenseInstance']}');
                    }
                    final value = doc.data()!['expenseInstance'];
                    Map<String, Timestamp> data = {groupName: value};

                    // ---- set the group name & instance value from the groups database ----
                    _groupsAndExpenseInstances.addAll(data);
                    notifyListeners();
                    // print('group added');
                  }
                });
              }
            } else {
              print('user has no group');
              _hasOneGroup = false;
              notifyListeners();
            }
          }
        });

        // ---- set currentGroupNme ----
        if (prefs.getString(_currentUserGroupName) != null &&
            prefs.getString(_currentUserGroupName)!.isNotEmpty) {
          print('prefs : currentUserGroup is not null');
          print(prefs.getString(_currentUserGroupName));
          _currentUserGroup = prefs.getString(_currentUserGroupName)!;
          // notifyListeners();
        } else {
          print('prefs : currentUserGroup is null or empty');
          _firebaseFirestoreRef
              .collection(_userCollectionName)
              .doc(currentUserEmail)
              .get()
              .then((DocumentSnapshot doc) {
            final profileInfo = doc.data() as Map<String, dynamic>;
            _currentUserName = profileInfo['userName'];
            final groupInfo = profileInfo['groupNames'] as List;
            if (groupInfo.isNotEmpty) {
              print(
                  'group info recieved from FirebaseFirestore & groupNames is not empty');
              print(groupInfo[0]);

              prefs.setString(_currentUserGroupName, groupInfo[0]);
              _currentUserGroup = groupInfo[0];
              notifyListeners();
            } else {
              _hasOneGroup = false;
              notifyListeners();
            }
          });

          if (kDebugMode) {
            print(_currentUserGroup);
          }
        }
      } else {
        _loggedIn = false;
      }
      print('currentUserGroup : $_currentUserGroup');
      print('currentUserName : $_currentUserName');
      print('currentUserEmail : $_currentUserEmail');
      notifyListeners();
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
      if (prefs.getString('currentUserEmail') != null &&
          prefs.getString('currentUserEmail')!.isNotEmpty) {
        _currentUserEmail = prefs.getString('currentUserEmail') ?? '';
        notifyListeners();
      }
    }
  }

  Future<void> refreshGroupNamesAndExpenseInstances() async {
    await setGroupAndExpenseInstances()
        .whenComplete(() async => await initCurrentUserGroup());
  }

  Future<void> setGroupAndExpenseInstances() async {
    // ---- set current user group instances ----
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
              if (doc.exists) {
                if (kDebugMode) {
                  print(
                      '(app_state 1) : expense instance : ${doc.data()!['expenseInstance']}');
                }
                final value = doc.data()!['expenseInstance'];
                Map<String, Timestamp> data = {groupName: value};

                // ---- set the group name & instance value from the groups database ----
                _groupsAndExpenseInstances.addAll(data);
                notifyListeners();
                // print('group added');
              }
            });
          }
        } else {
          print('user has no group');
          _hasOneGroup = false;
          notifyListeners();
        }
      }
    });
  }

  // ---- set currentUserGroup ----
  Future<void> initCurrentUserGroup({bypassState = false}) async {
    final prefs = await SharedPreferences.getInstance();
    // ---- set currentGroupNme ----
    if (!bypassState || _currentUserGroup.isEmpty) {
      if (!bypassState &&
          prefs.getString(_currentUserGroupName) != null &&
          prefs.getString(_currentUserGroupName)!.isNotEmpty) {
        print('prefs : currentUserGroup is not null');
        print(prefs.getString(_currentUserGroupName));
        _currentUserGroup = prefs.getString(_currentUserGroupName)!;
        // notifyListeners();
      } else {
        print('prefs : currentUserGroup is null or empty');
        _firebaseFirestoreRef
            .collection(_userCollectionName)
            .doc(currentUserEmail)
            .get()
            .then((DocumentSnapshot doc) {
          final profileInfo = doc.data() as Map<String, dynamic>;
          _currentUserName = profileInfo['userName'];
          final groupInfo = profileInfo['groupNames'] as List;
          if (groupInfo.isNotEmpty) {
            print(
                'group info recieved from FirebaseFirestore & groupNames is not empty');
            print(groupInfo[0]);

            prefs.setString(_currentUserGroupName, groupInfo[0]);
            _currentUserGroup = groupInfo[0];
            notifyListeners();
          } else {
            _hasOneGroup = false;
            notifyListeners();
          }
        });

        if (kDebugMode) {
          print(_currentUserGroup);
        }
      }
    }
  }

  printGroupMap() {
    _groupsAndExpenseInstances.forEach((key, value) {
      if (kDebugMode) {
        print('key : $key -- value: ${value.toDate()}');
      }
    });
  }

  // ---- set currentUserGroup variable ----
  Future<void> setCurrentUserGroup({required String currentUserGroup}) async {
    print('set group is called');
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
