import 'package:firebase_auth/firebase_auth.dart';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> signUpUser({String email, String password, String fullName});

  ResultFuture<UserEntity> signInUser({String email, String password});

  ResultFuture<void> signOutUser();

  ResultFuture<UserEntity> signInWithGoogle();

  ResultFuture<UserEntity> updateUserProfile({String? displayName, String? photoUrl, PhoneAuthCredential? phoneNumber, String? email});

  ResultFuture<void> sendVerificationOTP({required String email});

  ResultFuture<void> verifyUserEmail({required String email, required String otp});

  ResultFuture<void> sendResetVerificationOTP({required String email});
  
  ResultFuture<void> verifyResetOTP({required String email, required String otp, required String password});

  ResultFuture<void> createPassword({required String password, required String confirmPassword});
}