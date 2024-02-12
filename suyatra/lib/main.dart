import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_cubit.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/firebase_options.dart';

import 'constants/themes.dart';
import 'core/service_locator.dart';
import 'services/app_routes.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticleCubit>(
          create: (context) => ArticleCubit(
            getArticleCategoriesUseCase: locator(), 
            getFeaturedArticlesUseCase: locator(), 
            getPopularArticlesUseCase: locator(), 
            getAllArticlesUseCase: locator(),
            getArticleCommentsUseCase: locator(),
            addArticleCommentUseCase: locator(),
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            signUpUserUseCase: locator(),
            signInUserUseCase: locator(),
            signOutUserUseCase: locator(),
            signInWithGoogleUseCase: locator(),
          )
        )
      ],
      child: MaterialApp(
        title: 'Suyatra',
        themeMode: ThemeMode.system,
        theme: AppThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        navigatorKey: locator<NavigationService>().navigationKey,
        initialRoute: splashRoute,
      ),
    );
  }
}