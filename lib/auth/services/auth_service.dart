import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  late FirebaseFirestore _firebaseFirestore;
  final String _userCollectionName = 'user';

  AuthServices() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }
  // ------------- option, sign-in / register with google federated  -------------

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

// ------------- option, register with email & password -------------

  Future<void> emailRegisterUser(String inputUserName, String inputUserEmail,
      String inputUserPassword) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: inputUserEmail,
        password: inputUserPassword,
      )
          .whenComplete(() async {
        _firebaseFirestore
            .collection(_userCollectionName)
            .doc(inputUserEmail)
            .set(<String, dynamic>{
          'userName': inputUserName,
          'emailAddress': inputUserEmail,
          'color': '',
          'groupNames': []
        });
        // await UserDatabase().createUser(
        //     currentUserEmail: inputUserEmail,
        //     currentUserName: inputUserName,
        //     preferedColor: 'red');
      });

      // await UserServices().createUserProfile(preferedColor: 'red');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      rethrow;
    }
  }

// ------------- option, sign-in with email & password -------------

  Future<int> emailSignInUser(
      String inputUserEmail, String inputValueUserPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: inputUserEmail, password: inputValueUserPassword);
      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        return -2;
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        return -1;
      }
      return -3;
    }
  }
}
