import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class SignOutUserUseCase implements UseCaseWithoutParams {
  final AuthRepository _repository;
  SignOutUserUseCase(this._repository);
  

  @override
  ResultFuture<void> call() async {
    return await _repository.signOutUser();
  }
}


