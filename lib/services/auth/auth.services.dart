import 'package:firebase_auth/firebase_auth.dart';
import 'package:fraction/database/profile.database.dart';
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

Future<void> emailRegisterUser(
    String name, String emailAddress, String password) async {
  //var credential;

  List? _groupIds = [];

  try {
    print('register');

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    createUserProfile(name, emailAddress, name);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }

  //return credential;
}

// ------------- option, sign-in with email & password -------------

Future<void> emailSignInUser(String currentUserEmail, String password) async {
  List? _groupIds = [];

  try {
    final currentUserDetails = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: currentUserEmail, password: password)
        .then((credentials) {
      return getCurrentUserProfile(currentUserEmail);
    });

    print('------------ printing current user details ------------');
    print(currentUserDetails);

    ProfileModel profile = ProfileModel(
        currentUserName: currentUserDetails['name'],
        currentUserEmail: currentUserEmail);

    await insertProfile(profile);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

// ------------- option, sign-out -------------

Future<void> signOut() async => await FirebaseAuth.instance.signOut();
