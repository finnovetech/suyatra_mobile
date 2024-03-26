import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/data/datasource/auth_data_source.dart';
import 'package:suyatra/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';
import 'package:suyatra/features/authentication/domain/usecases/create_password_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/get_user_details_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/send_reset_verification_otp_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_in_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_out_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_up_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/update_user_profile_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/send_verification_otp_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/verify_reset_otp_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/verify_user_email_use_case.dart';

authDI() {
  //usecases
  locator.registerLazySingleton(() => SignUpUserUseCase(locator()));
  locator.registerLazySingleton(() => SignInUserUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUserUseCase(locator()));
  locator.registerLazySingleton(() => SignInWithGoogleUseCase(locator()));
  locator.registerLazySingleton(() => UpdateUserProfileUseCase(locator()));
  locator.registerLazySingleton(() => SendVerificationOTPUseCase(locator()));
  locator.registerLazySingleton(() => VerifyUserEmailUseCase(locator()));
  locator.registerLazySingleton(() => SendResetVerificationOTPUseCase(locator()));
  locator.registerLazySingleton(() => VerifyResetOTPUseCase(locator()));
  locator.registerLazySingleton(() => CreatePasswordUseCase(locator()));
  locator.registerLazySingleton(() => GetUserDetailsUseCase(locator()));
  
  //repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator()));

  //data sources
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(locator()));
}