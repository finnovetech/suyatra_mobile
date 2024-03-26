import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/string_constants.dart';
import '../../core/service_locator.dart';
import '../shared_preference_service.dart';

class ApiBaseHelper {
  Future<http.Response> get(String url, {String? cacheKey, String? userToken}) async {
    try {
      String? token = await locator<SharedPreferencesService>().getToken()??userToken;

      if(token == null) {
        throw youNeedToSignIn;
      }

      ///Refresh token if about to expire or is expired
      // if(isTokenExpired(token) || aboutToExpire(token)) {
      //   token = await refreshToken();
      // }
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      //401: lacks valid authentication credentials
      // if(response.statusCode == 401) {
      //   token = await refreshToken();
      // }

      if(response.statusCode == 200) {
        // if(cacheKey != null) {
        //   final eTagAPI = response.headers['etag'];
        //   locator<CacheManagerService>().cacheFile(uri: url, bytes: response.bodyBytes, cacheKey: cacheKey, eTagAPI: eTagAPI);
        // }
        return response;
      } else {
        return response;
      }
    } catch(exception) {
      rethrow;
    }
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? data, String? userToken}) async {
    try {
      String? token = await locator<SharedPreferencesService>().getToken()??userToken;

      if(token == null) {
        throw youNeedToSignIn;
      }

      ///Refresh token if about to expire or is expired
      // if(isTokenExpired(token) || aboutToExpire(token)) {
      //   token = await refreshToken();
      // }

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      };

      if(data != null) {
        final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(data));
        //401: lacks valid authentication credentials
        // if(response.statusCode == 401) {
        //   token = await refreshToken();
        // }

        return response;
      } else {
        final response = await http.post(Uri.parse(url), headers: headers);

        //401: lacks valid authentication credentials
        // if(response.statusCode == 401) {
        //   token = await refreshToken();
        // }

        return response;
      }
    } catch(exception) {
      rethrow;
    }
  }

  Future<http.Response> put(String url, {Map<String, dynamic>? data, String? userToken}) async {
    try {
      String? token = await locator<SharedPreferencesService>().getToken()??userToken;

      if(token == null) {
        throw youNeedToSignIn;
      }

      ///Refresh token if about to expire or is expired
      // if(isTokenExpired(token) || aboutToExpire(token)) {
      //   token = await refreshToken();
      // }

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      };

      if(data != null) {
        final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(data));

        //401: lacks valid authentication credentials
        // if(response.statusCode == 401) {
        //   token = await refreshToken();
        // }

        return response;
      } else {
        final response = await http.put(Uri.parse(url), headers: headers);

        //401: lacks valid authentication credentials
        // if(response.statusCode == 401) {
        //   token = await refreshToken();
        // }

        return response;
      }
    } catch(exception) {
      rethrow;
    }
  }

  Future<http.Response> getWithoutToken(String url) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json"
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      return response;
    } catch(exception) {
      rethrow;
    }
  }

   Future<http.Response> postWithoutToken(String url, {Map<String, dynamic>? data}) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(data));
      return response;
    } catch(exception) {
      rethrow;
    }
  }
}