import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'auth/profile.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  String? _currentUserName = 'name';
  String get currentUserName => _currentUserName ?? 'name not set';

  String? _currentUserEmail = 'email';
  String get currentUserEmail => _currentUserEmail ?? 'email not set';

  List? _groupIds = [];
  List get groupIds => _groupIds?? [];

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

  Future<void> emailSignInUser(String emailAddress, String password) async {
  try {
    final currentUserDetails = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password)
        .then((credentials) {
          return getCurrentUserProfile(credentials.user?.email);
        });

        _currentUserEmail = currentUserDetails['email'];
        _currentUserName = currentUserDetails['name'];
        _groupIds = currentUserDetails['group_id'];

        getCurrentUserProfile(_currentUserEmail);

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

}
