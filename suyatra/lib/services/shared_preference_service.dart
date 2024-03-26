import 'package:shared_preferences/shared_preferences.dart';

import '../core/service_locator.dart';
import 'google_auth_service.dart';

class SharedPreferencesService {
  static const tokenKey = "TOKEN";
  
  ///Used to save user token
  saveToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, value);
  }
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(tokenKey);
    return token;
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (await locator<GoogleAuthService>().isLoggedIn()) {
      locator<GoogleAuthService>().logout();
    }
  }
}