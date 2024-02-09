import 'package:dartz/dartz.dart';
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
  ResultFuture<UserEntity> signUpUser({
    String? email,
    String? password,
  }) async {
    try {
      final result = await _authDataSource.signUpUser(
        email: email!, 
        password: password!,
      );
      return Right(result!);
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
}