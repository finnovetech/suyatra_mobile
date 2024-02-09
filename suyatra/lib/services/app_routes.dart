import 'package:flutter/material.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/features/articles/presentation/pages/articles_list_page.dart';
import 'package:suyatra/features/articles/presentation/widgets/web_view_external_links.dart';
import 'package:suyatra/features/authentication/presentation/pages/login_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/sign_up_page.dart';
// ignore: unused_import
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/pages/home_page.dart';

import '../features/articles/presentation/pages/article_details_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

//splash route names
const String splashRoute = "splashRoute";

//auth route names
const String loginRoute = "loginRoute";
const String signUpRoute = "signUpRoute";

//home route names
const String homeRoute = "homeRoute";

//articles route names
const String articleDetailsRoute = "articleDetailsRoute";
const String articlesListRoute = "articlesListRoute";
const String webViewRoute = "webViewRoute";



Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //splash routes
    case splashRoute:
      return customPageRoute(child: const SplashPage(), routeSettings: settings);
    //auth routes
    case loginRoute:
      String? navigateBackTo = (settings.arguments as Map)["route"];
      //if navigate back to article details page, get article
      ArticleEntity? article = (settings.arguments as Map)["article"];
      return customPageRoute(child: LoginPage(navigateBackTo: navigateBackTo, article: article,), routeSettings: settings);
    case signUpRoute:
      String? navigateBackTo = (settings.arguments as Map)["route"];
      //if navigate back to article details page, get article
      ArticleEntity? article = (settings.arguments as Map)["article"];
      return customPageRoute(child: SignUpPage(navigateBackTo: navigateBackTo, article: article,), routeSettings: settings);
    
    //home routes
    case homeRoute:
      return customPageRoute(child: const HomePage(), routeSettings: settings);
    case articleDetailsRoute:
      ArticleEntity article = (settings.arguments as Map)["article"];
      String heroTag = (settings.arguments as Map)["tag"];
      bool? scrollToComment = (settings.arguments as Map)["scroll_to_comment"];
      return customPageRoute(
        child: ArticleDetailsPage(
          article: article, 
          heroTag: heroTag, 
          scrollToComment: scrollToComment,
        ), 
        routeSettings: settings,
      );
    case articlesListRoute:
      ArticleType type = (settings.arguments as ArticleType?) ?? ArticleType.all;
      return customPageRoute(child: ArticlesListPage(articleType: type), routeSettings: settings);
    case webViewRoute:
      String url = settings.arguments as String;
      return customPageRoute(child: WebViewExternalUrls(url: url,), routeSettings: settings);
    default:
      return MaterialPageRoute(builder: (context) => Material(child: Center(child: Text("No such route ${settings.name}"),)));
  }
}

Route<dynamic> customPageRoute({
  required Widget child,
  required RouteSettings routeSettings,
}) {
  return MaterialPageRoute(
    builder: (BuildContext context) {
      return child;
    },
    settings: routeSettings,
  );
}