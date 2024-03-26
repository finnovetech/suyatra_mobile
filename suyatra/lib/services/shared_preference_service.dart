import 'package:shared_preferences/shared_preferences.dart';

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
}