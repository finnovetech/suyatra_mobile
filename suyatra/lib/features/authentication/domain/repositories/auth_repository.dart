import 'package:firebase_auth/firebase_auth.dart';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> signUpUser({String email, String password});

  ResultFuture<UserEntity> signInUser({String email, String password});

  ResultFuture<void> signOutUser();

  ResultFuture<UserEntity> signInWithGoogle();

  ResultFuture<UserEntity> updateUserProfile({String? displayName, String? photoUrl, PhoneAuthCredential? phoneNumber, String? email});

  ResultFuture<void> verifyUserEmail();
}