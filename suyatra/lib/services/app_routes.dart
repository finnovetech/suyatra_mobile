import 'package:flutter/material.dart';
import 'package:suyatra/features/account/presentation/pages/guest/guest_account_delete_page.dart';
import 'package:suyatra/features/account/presentation/pages/guest/guest_account_settings_page.dart';
import 'package:suyatra/features/account/presentation/pages/support_page.dart';
import 'package:suyatra/features/activities/presentation/pages/activity_notifications/activity_notification_settings_page.dart';
import 'package:suyatra/features/activities/presentation/pages/activity_notifications/activity_notifications_page.dart';
import 'package:suyatra/features/activities/presentation/pages/create_activity/create_activity_page.dart';
import 'package:suyatra/features/articles/presentation/pages/articles_list_page.dart';
import 'package:suyatra/features/articles/presentation/widgets/web_view_external_links.dart';
import 'package:suyatra/features/authentication/presentation/pages/login/create_password_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/login/forgot_password_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/login/login_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/sign_up/email_verification_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/sign_up/sign_up_page.dart';
// ignore: unused_import
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/pages/explore_page.dart';
import 'package:suyatra/features/authentication/presentation/pages/sign_up/welcome_page.dart';
import 'package:suyatra/features/home/presentation/pages/home_page.dart';
import 'package:suyatra/features/layout/presentation/pages/layout_page.dart';
import 'package:suyatra/features/settings/presentation/pages/edit_user_profile_page.dart';
import 'package:suyatra/features/settings/presentation/pages/settings_page.dart';

import '../features/articles/presentation/pages/article_details_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

//splash route names
const String splashRoute = "splashRoute";

//auth route names
const String welcomeRoute = "welcomeRoute";
const String loginRoute = "loginRoute";
const String signUpRoute = "signUpRoute";
const String emailVerificationRoute = "emailVerificationRoute";
const String forgotPasswordRoute ="forgotPasswordRoute";
const String createPasswordRoute = "createPasswordRoute";

//home route names
const String homeRoute = "homeRoute";

//explore route names
const String exploreRoute = "exploreRoute";

//articles route names
const String articleDetailsRoute = "articleDetailsRoute";
const String articlesListRoute = "articlesListRoute";
const String webViewRoute = "webViewRoute";

//settings route names
const String settingsRoute = "settingsRoute";
const String editUserProfileRoute = "editUserProfileRoute";

//layout route names
const String layoutRoute = "layoutRoute";

//activity route names
const String activityNotificationsRoute = "activityNotificationsRoute";
const String activityNotificationSettingsRoute = "activityNotificationSettingsRoute";
const String createActivityRoute = "createActivityRoute";

//account route names
const String supportRoute = "supportRoute";
const String guestAccountSettingsRoute = "guestAccountSettingsRoute";
const String guestAccountDeleteRoute = "guestAccountDeleteRoute";

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //splash routes
    case splashRoute:
      return customPageRoute(child: const SplashPage(), routeSettings: settings);

    //auth routes
    case welcomeRoute:
      return customPageRoute(child: const WelcomePage(), routeSettings: settings);
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
    case emailVerificationRoute:
      bool isSignUp = (settings.arguments as bool?) ?? true;
      return customPageRoute(child: EmailVerificationPage(isSignUp: isSignUp), routeSettings: settings);
    case forgotPasswordRoute:
      return customPageRoute(child: const ForgotPasswordPage(), routeSettings: settings);
    case createPasswordRoute:
      return customPageRoute(child: const CreatePasswordPage(), routeSettings: settings);
    
    
    //explore routes
    case homeRoute:
      return customPageRoute(child: const HomePage(), routeSettings: settings);

    //explore routes
    case exploreRoute:
      return customPageRoute(child: const ExplorePage(), routeSettings: settings);

    //layout routes
    case layoutRoute:
      return customPageRoute(child: const LayoutPage(), routeSettings: settings);

    //article routes
    case articleDetailsRoute:
      ArticleEntity article = (settings.arguments as Map)["article"];
      String heroTag = (settings.arguments as Map)["tag"];
      bool? scrollToComment = (settings.arguments as Map)["scroll_to_comment"];
      return customPageRoute(
        child: ArticleDetailsPage(
          slug: article.slug!, 
          heroTag: heroTag, 
          scrollToComment: scrollToComment,
        ), 
        routeSettings: settings,
      );
    case articlesListRoute:
      return customPageRoute(child: const ArticlesListPage(), routeSettings: settings);
    case webViewRoute:
      String url = settings.arguments as String;
      return customPageRoute(child: WebViewExternalUrls(url: url,), routeSettings: settings);
      
    //settings routes
    case settingsRoute:
      return customPageRoute(child: const SettingsPage(), routeSettings: settings);
    case editUserProfileRoute:
      return customPageRoute(child: const EditUserProfilePage(), routeSettings: settings);

    //activity routes
    case activityNotificationsRoute:
      return customPageRoute(child: const ActivityNotificationsPage(), routeSettings: settings);
    case activityNotificationSettingsRoute:
      return customPageRoute(child: const ActivityNotificationSettingsPage(), routeSettings: settings);
    case createActivityRoute:
      return customPageRoute(child: const CreateActivityPage(), routeSettings: settings);
    //account routes
    case supportRoute:
      return customPageRoute(child: const SupportPage(), routeSettings: settings);
    case guestAccountSettingsRoute:
      return customPageRoute(child: const GuestAccountSettingsPage(), routeSettings: settings);
    case guestAccountDeleteRoute:
      return customPageRoute(child: const GuestAccountDeletePage(), routeSettings: settings);
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