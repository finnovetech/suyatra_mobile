import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

class GetUserDetailsUseCase extends UseCaseWithoutParams<UserEntity> {
  final AuthRepository _authRepository;
  GetUserDetailsUseCase(this._authRepository);

  @override
  ResultFuture<UserEntity> call() async {
    return await _authRepository.getUserDetails();
  }
}