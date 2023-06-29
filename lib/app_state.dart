import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'services/profile/profile.services.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  List? _groupIds = [];
  List get groupIds => _groupIds ?? [];

  // Map profileInfo;

  // ------------- Firebase Initailization -------------

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  void setUserProfile(currentUserDetails) async {
    final prefs = await SharedPreferences.getInstance();

    if (currentUserDetails == null) {
      await prefs.setString('currentUserEmail', currentUserDetails['email']);
      await prefs.setString('currentUserName', currentUserDetails['name']);

      print('--------------fuck you ---------------');
      print(prefs.getString('currentUserEmail'));
    } else {
      print('Debug: ---- currentUserDetails is null ----');
    }
  }

  Future<void> emailSignInUser(String emailAddress, String password) async {
    try {
      final currentUserDetails = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((credentials) {
        return getCurrentUserProfile(credentials.user?.email);
      });

      _groupIds = currentUserDetails['group_id'];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
