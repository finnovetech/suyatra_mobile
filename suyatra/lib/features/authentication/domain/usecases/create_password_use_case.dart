import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class CreatePasswordUseCase extends UseCaseWithParams<void, CreatePasswordParams> {
  final AuthRepository _authRepository;
  CreatePasswordUseCase(this._authRepository);

  @override
  ResultFuture<void> call(CreatePasswordParams params) async {
    return await _authRepository.createPassword(
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}

class CreatePasswordParams {
  final String password;
  final String confirmPassword;
  CreatePasswordParams({
    required this.password,
    required this.confirmPassword,
  });
}