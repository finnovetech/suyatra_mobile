import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class VerifyUserEmailUseCase extends UseCaseWithParams<void, VerifyUserEmailParams> {
  final AuthRepository _authRepository;
  VerifyUserEmailUseCase(this._authRepository);

  @override
  ResultFuture<void> call(VerifyUserEmailParams params) async {
    return await _authRepository.verifyUserEmail(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyUserEmailParams {
  final String email;
  final String otp;

  VerifyUserEmailParams({required this.email, required this.otp});
}