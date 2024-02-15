import 'package:firebase_auth/firebase_auth.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/typedef.dart';

class UpdateUserProfileUseCase implements UseCaseWithParams<UserEntity, UpdateUserProfileParams> {
  final AuthRepository _repository;
  UpdateUserProfileUseCase(this._repository);
  

  @override
  ResultFuture<UserEntity> call(UpdateUserProfileParams params) async {
    return await _repository.updateUserProfile(
       displayName: params.displayName,
       photoUrl: params.photoUrl,
       phoneNumber: params.phoneNumber,
       email: params.email,
    );
  }
}

class UpdateUserProfileParams {
  final String? displayName;
  final String? photoUrl;
  final PhoneAuthCredential? phoneNumber;
  final String? email;

  UpdateUserProfileParams({required this.displayName, required this.photoUrl, required this.phoneNumber, required this.email,});
}



