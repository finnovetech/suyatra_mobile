import 'package:firebase_auth/firebase_auth.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/data/models/user_model.dart';
import 'package:suyatra/services/firebase_service.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/firebase_error_messages.dart';

abstract class AuthDataSource {
  Future<UserModel?> signUpUser({required String email, required String password});
  Future<UserModel?> signInUser({required String email, required String password});
  Future<void> signOutUser();
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
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}