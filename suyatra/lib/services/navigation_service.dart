import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  navigateTo(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  navigateToAndBack(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  navigateToAndRemoveAll(String routeName, {dynamic arguments}) {
    return navigationKey.currentState!.pushNamedAndRemoveUntil(
        routeName, arguments: arguments, (route) => false);
  }

  goBack({dynamic arguments}) {
    return navigationKey.currentState!.pop(arguments);
  }
}