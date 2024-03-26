import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class VerifyResetOTPUseCase extends UseCaseWithParams<void, VerifyResetOTPParams> {
  final AuthRepository _authRepository;
  VerifyResetOTPUseCase(this._authRepository);

  @override
  ResultFuture<void> call(VerifyResetOTPParams params) async {
    return await _authRepository.verifyResetOTP(
      email: params.email,
      otp: params.otp,
      password: params.password,
    );
  }
}

class VerifyResetOTPParams {
  final String otp;
  final String email;
  final String password;
  VerifyResetOTPParams({
    required this.otp,
    required this.email,
    required this.password,
  });
}