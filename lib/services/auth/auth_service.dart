// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/exception/exception.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in anonymously

  //This methode is not used in the app but it is a good example of how to sign in anonymously
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        print('Signed in anonymously: ${user.uid}');
      }
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  //sign in anonymously with auth exceptions ( this is the one used in the app)
  Future<void> signInAnonymouslywithExceptions() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        print('Signed in anonymously: ${user.uid}');
      }
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in anonymously: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  // Sign out
  //This methode will sign out the user and print a message to the console
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get the current user
  //This methode will return the current user , here the user is the one that is signed in and fierbase will return the user and we can use it to get the user data (uid, email...)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //create user with email and password
  //This methode will create a new user with email and password and return the user credential
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  //sign in with email and password
  //This methode will sign in the user with email and password
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("user sign in successfuly");
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');

      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  //sign in with google
  //This methode will sign in the user with google
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the GoogleSignInAuthentication object
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Prepare user data
        final UserModel newUser = UserModel(
          userId: user.uid,
          name: user.displayName ?? "No name",
          email: user.email ?? "No",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: "",
        );

        // Save user to Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await userDocRef.set(newUser.toJson());


        print("user data saved google sign in");
      }
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with Google: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  //github sign in
  //This methode will sign in the user with github
  Future<void> signInWithGitHub() async {
    try {
      // Trigger the GitHub Sign In process here the user will be redirected to the github page to sign in , this is done by the githubAuthProvider and the auth package from firebase
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with GitHub: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with GitHub: $e');
    }
  }

  // Send password reset email

  //This methode will send a password reset email to the user , the user will receive an email with a link to reset the password (Not used in the app)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      print(
          'Error sending password reset email: ${mapFirebaseAuthExceptionCode(e.code)}');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }
}
