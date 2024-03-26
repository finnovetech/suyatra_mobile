import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class SignUpUserUseCase implements UseCaseWithParams<UserEntity, SignUpUserParams> {
  final AuthRepository _repository;
  SignUpUserUseCase(this._repository);
  

  @override
  ResultFuture<UserEntity> call(SignUpUserParams params) async {
    return await _repository.signUpUser(
       email: params.email,
       password: params.password,
       fullName: params.fullName,
    );
  }
}

class SignUpUserParams {
  final String email;
  final String password;
  final String fullName;

  SignUpUserParams({required this.email, required this.password, required this.fullName});
}



