import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suyatra/core/exceptions.dart';
import 'package:suyatra/core/failure.dart';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/authentication/data/datasource/auth_data_source.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  ResultFuture<void> signUpUser({
    String? email,
    String? password,
    String? fullName,
  }) async {
    try {
      final result = await _authDataSource.signUpUser(
        email: email!, 
        password: password!,
        fullName: fullName!,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserEntity> signInUser({
    String? email,
    String? password,
  }) async {
    try {
      final result = await _authDataSource.signInUser(
        email: email!, 
        password: password!,
      );
      return Right(result!);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }
  
  @override
  ResultFuture<void> signOutUser() async {
    try {
      final result = await _authDataSource.signOutUser();
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserEntity> signInWithGoogle() async {
    try {
      final result = await _authDataSource.signInWithGoogle();
      return Right(result!);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserEntity> updateUserProfile({String? displayName, String? photoUrl, PhoneAuthCredential? phoneNumber, String? email}) async {
    try {
      final result = await _authDataSource.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        email: email,
      );
      return Right(result!);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sendVerificationOTP({required String email}) async {
    try {
      final result = await _authDataSource.sendVerificationOTP(email: email);
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> verifyUserEmail({required String email, required String otp}) async {
    try {
      final result = await _authDataSource.verifyUserEmail(
        email: email,
        otp: otp,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> sendResetVerificationOTP({required String email}) async {
    try {
      final result = await _authDataSource.sendResetVerificationOTP(email: email);
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> verifyResetOTP({required String email, required String otp, required String password}) async {
    try {
      final result = await _authDataSource.verifyResetOTP(
        email: email,
        otp: otp,
        password: password,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> createPassword({required String password, required String confirmPassword}) async {
    try {
      final result = await _authDataSource.createPassword(
        password: password,
        confirmPassword: confirmPassword,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserEntity> getUserDetails() async {
    try {
      final result = await _authDataSource.getUserDetails();
      return Right(result!);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

}