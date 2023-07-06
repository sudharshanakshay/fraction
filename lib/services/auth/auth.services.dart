import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/group.dart';
import 'package:fraction/model/profile.dart';
import 'package:fraction/services/profile/profile.services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: inputUserEmail,
      password: inputUserPassword,
    );
    //     .whenComplete(() async {
    //   insertCurrentProfileToLocalDatabase(ProfileModel(
    //       currentUserName: inputUserName, currentUserEmail: inputUserEmail));
    // });
    createUserProfile(
        userName: inputUserName,
        currentUserEmail: inputUserEmail,
        color: 'red');
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

Future<void> emailSignInUser(
    String inputUserEmail, String inputValueUserPassword) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: inputUserEmail, password: inputValueUserPassword);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      debugPrint('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      debugPrint('Wrong password provided for that user.');
    }
  }
}

// ------------- option, sign-out -------------

void signOut() async {
  FirebaseAuth.instance.signOut();
  // await clearProfileDetailsFromLocalStorage()
  //     .whenComplete(() => FirebaseAuth.instance.signOut());
}
