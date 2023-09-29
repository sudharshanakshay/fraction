import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/data/api/utils/database.utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  final String _currentUserGroupName = 'currentUserGroupName';
  final String _settingsUseRandomDashboardColorName = 's-drc';

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

  bool _toggleRandomDashboardColor = false;
  get toggleRandomDashboardColor => _toggleRandomDashboardColor;

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

        // ---- try ----

        print("----  printing chats ----");

        _firebaseFirestoreRef
            .collection('chat')
            .doc(currentUserEmail)
            .collection('chat')
            .get()
            .then((doc) {
          for (var chat in doc.docs) {
            if (chat.exists) {
              // groupList.add(chatDetails['groupName']);

              _firebaseFirestoreRef
                  .collection(_groupCollectionName)
                  .doc(chat.id)
                  .get()
                  .then((doc) {
                if (doc.exists) {
                  final value = doc.data()!['expenseInstance'];
                  Map<String, Timestamp> data = {chat.id: value};

                  // print(data);

                  // ---- set the group name & instance value from the groups database ----
                  _groupsAndExpenseInstances.addAll(data);
                  notifyListeners();
                  // print('group added');
                } else {
                  // print(chatDetails['groupName']);
                }
              });
            }
          }
        });

        // ---- set current user name ----

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
          }
        });

        // ---- set current user group instances ----
        // _firebaseFirestoreRef
        //     .collection(_userCollectionName)
        //     .doc(_currentUserEmail)
        //     .get()
        //     .then((DocumentSnapshot doc) async {
        //   if (doc.exists) {
        //     final currentProfileDetails = doc.data() as Map<String, dynamic>;
        //     // ---- set current user name from user database ----
        //     _currentUserName = currentProfileDetails['userName'];
        //     notifyListeners();

        //     final groupList = currentProfileDetails['groupNames'] as List;
        //     if (groupList.isNotEmpty) {
        //       _hasOneGroup = true;
        //       for (String groupName in groupList) {
        //         // ---- get values from group database ----

        //         _firebaseFirestoreRef
        //             .collection(_groupCollectionName)
        //             .doc(groupName)
        //             .get()
        //             .then((doc) {
        //           if (doc.exists) {
        //             final value = doc.data()!['expenseInstance'];
        //             Map<String, Timestamp> data = {groupName: value};

        //             print(data);

        //             // ---- set the group name & instance value from the groups database ----
        //             _groupsAndExpenseInstances.addAll(data);
        //             notifyListeners();
        //             // print('group added');
        //           }
        //         });
        //       }
        //     } else {
        //       if (kDebugMode) {
        //         print('user has no group');
        //       }
        //       _hasOneGroup = false;
        //       notifyListeners();
        //     }
        //   }
        // });

        // ---- set currentGroupNme ----
        if (prefs.getString(_currentUserGroupName) != null &&
            prefs.getString(_currentUserGroupName)!.isNotEmpty) {
          if (kDebugMode) {
            print('prefs : currentUserGroup is neither null or empty');
            print(prefs.getString(_currentUserGroupName));
          }

          _currentUserGroup = prefs.getString(_currentUserGroupName)!;
          // notifyListeners();
        } else {
          if (kDebugMode) {
            print('prefs : currentUserGroup is either null or empty');
          }
          _firebaseFirestoreRef
              .collection(_userCollectionName)
              .doc(currentUserEmail)
              .get()
              .then((DocumentSnapshot doc) {
            final profileInfo = doc.data() as Map<String, dynamic>;
            _currentUserName = profileInfo['userName'];
            final groupInfo = profileInfo['groupNames'] as List;
            if (groupInfo.isNotEmpty) {
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

        if (prefs.getBool(_settingsUseRandomDashboardColorName) != null) {
          _toggleRandomDashboardColor =
              prefs.getBool(_settingsUseRandomDashboardColorName) ?? false;
        }
      } else {
        _loggedIn = false;
      }
      if (kDebugMode) {
        print('currentUserGroup : $_currentUserGroup');
        print('currentUserName : $_currentUserName');
        print('currentUserEmail : $_currentUserEmail');
      }

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
          for (String groupId in groupList) {
            // ---- get values from group database ----

            _firebaseFirestoreRef
                .collection(_groupCollectionName)
                .doc(groupId)
                .get()
                .then((doc) {
              if (doc.exists) {
                final value = doc.data()!['expenseInstance'];
                Map<String, Timestamp> data = {groupId: value};

                // ---- set the group name & instance value from the groups database ----
                _groupsAndExpenseInstances.addAll(data);
                notifyListeners();
              }
            });
          }
        } else {
          if (kDebugMode) {
            print('user has no group');
          }
          _hasOneGroup = false;
          notifyListeners();
        }
      }
    });
  }

  // ---- set currentUserGroup ----
  Future<void> initCurrentUserGroup({bypassState = false}) async {
    // ---- set currentGroupNme ----
    if (bypassState || _currentUserGroup.isEmpty) {
      final prefs = await SharedPreferences.getInstance();

      if (!bypassState &&
          prefs.getString(_currentUserGroupName) != null &&
          prefs.getString(_currentUserGroupName)!.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        if (kDebugMode) {
          print('prefs : currentUserGroup is neither null or empty');
          print(prefs.getString(_currentUserGroupName));
        }
        _currentUserGroup = prefs.getString(_currentUserGroupName)!;
      } else {
        if (kDebugMode) {
          print('prefs : currentUserGroup is either null or empty');
        }
        _firebaseFirestoreRef
            .collection(_userCollectionName)
            .doc(currentUserEmail)
            .get()
            .then((DocumentSnapshot doc) {
          final profileInfo = doc.data() as Map<String, dynamic>;
          _currentUserName = profileInfo['userName'];
          final groupInfo = profileInfo['groupNames'] as List;
          if (groupInfo.isNotEmpty) {
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

  Future<void> setRandomDashboardColor({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    _toggleRandomDashboardColor = value;
    prefs.setBool(_settingsUseRandomDashboardColorName, value);
  }

  Future<void> refreshRandomDashboardColor() async {
    final prefs = await SharedPreferences.getInstance();
    _toggleRandomDashboardColor =
        prefs.getBool(_settingsUseRandomDashboardColorName) ?? false;
  }

  // ---- set currentUserGroup variable ----
  Future<void> setCurrentUserGroup({required String currentUserGroup}) async {
    final prefs = await SharedPreferences.getInstance();

    _currentUserGroup = currentUserGroup;
    notifyListeners();

    await prefs.setString(_currentUserGroupName, currentUserGroup);
  }

  // ------------- option, sign-out -------------

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear().then((value) {
      if (value) {
        FirebaseAuth.instance.signOut();
        if (kDebugMode) {
          print('---- prefs clear complete ----');
        }
      } else {
        if (kDebugMode) {
          print('---- error clearing ----');
        }
      }
    });
  }
}
