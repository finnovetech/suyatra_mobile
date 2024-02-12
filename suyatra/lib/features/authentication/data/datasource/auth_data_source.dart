import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/data/models/user_model.dart';
import 'package:suyatra/services/firebase_service.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/firebase_error_messages.dart';

abstract class AuthDataSource {
  Future<UserModel?> signUpUser({required String email, required String password});
  Future<UserModel?> signInUser({required String email, required String password});
  Future<void> signOutUser();
  Future<UserModel?> signInWithGoogle();

}

class AuthDataSourceImpl implements AuthDataSource {

  @override
  Future<UserModel?> signUpUser({
    required String email,
    required String password,
    }) async {
    try {
      final UserCredential userCredential = await locator<FirebaseService>().firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim()
      );
      final User? firebaseUser = userCredential.user;
      if(firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid, 
          email: firebaseUser.email ?? "", 
          firstName: firebaseUser.displayName ?? "", 
          lastName: firebaseUser.displayName ?? "",
        );
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    }
    return null;
  }

  @override
  Future<UserModel?> signInUser({
    required String email,
    required String password,
    }) async {
    try {
      final UserCredential userCredential = await locator<FirebaseService>().firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim()
      );
      final User? firebaseUser = userCredential.user;
      if(firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid, 
          email: firebaseUser.email ?? "", 
          firstName: firebaseUser.displayName ?? "", 
          lastName: firebaseUser.displayName ?? "",
        );
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    }
    return null;
  }

  @override
  Future<void> signOutUser() async {
    final User? firebaseUser = locator<FirebaseService>().firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await GoogleSignIn().signOut();
      await locator<FirebaseService>().firebaseAuth.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if(firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid, 
          email: firebaseUser.email ?? "", 
          firstName: firebaseUser.displayName ?? "", 
          lastName: firebaseUser.displayName ?? "",
        );
      }

    } on FirebaseAuthException catch (e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    }
    return null;
  }
}