import 'package:get_it/get_it.dart';
import 'package:suyatra/features/authentication/presentation/auth_di.dart';
import 'package:suyatra/services/firebase_service.dart';
import 'package:suyatra/services/google_auth_service.dart';
import 'package:suyatra/services/shared_preference_service.dart';

import '../features/articles/presentation/article_di.dart';
import '../services/api_service/api_base_helper.dart';
import '../services/navigation_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiBaseHelper());

  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => FirebaseService());

  locator.registerLazySingleton(() => GoogleAuthService());

  locator.registerLazySingleton(() => SharedPreferencesService());
  
  articleDI();
  authDI();
}