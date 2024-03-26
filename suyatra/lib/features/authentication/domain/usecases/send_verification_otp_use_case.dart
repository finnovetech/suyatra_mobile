import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class SendVerificationOTPUseCase implements UseCaseWithParams<void, SendVerificationOTPParams> {
  final AuthRepository _repository;
  SendVerificationOTPUseCase(this._repository);
  

  @override
  ResultFuture<void> call(SendVerificationOTPParams params) async {
    return await _repository.sendVerificationOTP(email: params.email);
  }
}

class SendVerificationOTPParams {
  final String email;
  SendVerificationOTPParams({required this.email});
}


