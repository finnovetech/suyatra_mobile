import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class SignInWithGoogleUseCase implements UseCaseWithoutParams {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);
  

  @override
  ResultFuture call() async {
    return await _repository.signInWithGoogle();
  }
}



