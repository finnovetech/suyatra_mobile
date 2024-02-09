import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class SignInUserUseCase implements UseCaseWithParams<UserEntity, SignInUserParams> {
  final AuthRepository _repository;
  SignInUserUseCase(this._repository);
  

  @override
  ResultFuture<UserEntity> call(SignInUserParams params) async {
    return await _repository.signInUser(
       email: params.email,
       password: params.password,
    );
  }
}

class SignInUserParams {
  final String email;
  final String password;

  SignInUserParams({required this.email, required this.password});
}



