import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FractionServices extends ChangeNotifier {
  FractionServices() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  String _currentUserEmail = '';
  String get currentUserEmail => _currentUserEmail;

  String _currentUserGroup = '';
  String get currentUserGroup => _currentUserGroup;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _currentUserEmail = user.email!;
        print("current group value ${_currentUserGroup}");
        if (_currentUserGroup.isEmpty) {
          try {
            FirebaseFirestore.instance
                .collection('profile')
                .doc(_currentUserEmail)
                .get()
                .then((DocumentSnapshot doc) {
              final currentProfileDetails = doc.data() as Map<String, dynamic>;
              for (String groupName in currentProfileDetails['groupNames']) {
                if (groupName.isNotEmpty) {
                  print('---- printing group name from expense services ----');
                  print(groupName);
                  _currentUserGroup = groupName;
                  notifyListeners();
                  break;
                }
              }
            });
          } catch (e) {
            throw ('user has no group');
          }

          notifyListeners();
        }
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  // ---- set currentGroupName variable ----
  Future<void> setCurrentGroupName({required String currentGroupName}) async {
    _currentUserGroup = currentGroupName;
    notifyListeners();
    print('current group -> $_currentUserGroup');
  }
}
