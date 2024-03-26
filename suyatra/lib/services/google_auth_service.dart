import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final _googleSignIn = GoogleSignIn(
    clientId: Platform.isAndroid
      ? null
      : "418306283462-74sht1s4a366bds0mr850rfa3s4kd9qq.apps.googleusercontent.com",
  );

  Future<bool> isLoggedIn() => _googleSignIn.isSignedIn();

  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  Future logout() => _googleSignIn.signOut();
}