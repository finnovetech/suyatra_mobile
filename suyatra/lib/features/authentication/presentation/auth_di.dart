import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/data/datasource/auth_data_source.dart';
import 'package:suyatra/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:suyatra/features/authentication/domain/repositories/auth_repository.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_in_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_out_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_up_user_use_case.dart';

authDI() {
  //usecases
  locator.registerLazySingleton(() => SignUpUserUseCase(locator()));
  locator.registerLazySingleton(() => SignInUserUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUserUseCase(locator()));
  
  //repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator()));

  //data sources
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());
}