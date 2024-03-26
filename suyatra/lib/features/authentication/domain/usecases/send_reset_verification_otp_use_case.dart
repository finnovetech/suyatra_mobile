import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class SendResetVerificationOTPUseCase extends UseCaseWithParams<void, SendResetVerificationOTPParams> {
  final AuthRepository _authRepository;
  SendResetVerificationOTPUseCase(this._authRepository);

  @override
  ResultFuture<void> call(SendResetVerificationOTPParams params) async {
    return await _authRepository.sendResetVerificationOTP(
      email: params.email,
    );
  }
}

class SendResetVerificationOTPParams {
  final String email;
  SendResetVerificationOTPParams({required this.email});
}

