import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:suyatra/constants/url_constants.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/data/models/user_model.dart';
import 'package:suyatra/services/api_service/api_base_helper.dart';
import 'package:suyatra/services/firebase_service.dart';
import 'package:suyatra/utils/toast_message.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/firebase_error_messages.dart';

abstract class AuthDataSource {
  Future<UserModel?> signUpUser({required String email, required String password, required String fullName});
  Future<UserModel?> signInUser({required String email, required String password});
  Future<void> signOutUser();
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> updateUserProfile({String? displayName, required String? photoUrl, required PhoneAuthCredential? phoneNumber, required String? email});
  Future<void> sendVerificationOTP({required String email});
  Future<void> verifyUserEmail({required String email, required String otp});
  Future<void> sendResetVerificationOTP({required String email});
  Future<void> verifyResetOTP({required String email, required String otp, required String password});
  Future<void> createPassword({required String password, required String confirmPassword});
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiBaseHelper _apiBaseHelper;

  AuthDataSourceImpl(this._apiBaseHelper);

  @override
  Future<UserModel?> signUpUser({
    required String email,
    required String password,
    required String fullName,
    }) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/register-user/",
        data: {
          "email": email,
          "password": password,
          "first_name": fullName.split(" ").first,
          "last_name": fullName.split(" ").last
        }
      );
      if(response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        return UserModel.fromJson(decodedResponse);
      } else {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch (e) {
      throw APIException(message: jsonDecode(e.message)["details"][0], statusCode: -1);
    }
  }

  @override
  Future<UserModel?> signInUser({
    required String email,
    required String password,
    }) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/token/",
        data: {
          "email": email,
          "password": password,
        }
      );
      if(response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        return UserModel.fromJson(decodedResponse);
      } else {
        throw APIException(message: response.body, statusCode: -1);
      }
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<void> signOutUser() async {
    final User? firebaseUser = locator<FirebaseService>().firebaseAuth.currentUser;
    await GoogleSignIn().signOut();
    if (firebaseUser != null) {
      await locator<FirebaseService>().firebaseAuth.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      signOutUser();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if(googleAuth != null) {
        final response = await _apiBaseHelper.postWithoutToken(
          "$baseUrl/login-with-google/",
          data: {
            "auth_token": googleAuth.accessToken,
          }
        );

        if(response.statusCode == 200) {
          return UserModel.fromJson(response.body);
        }
      }
    } on FirebaseAuthException catch (e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    }
    return null;
  }

  @override
  Future<UserModel?> updateUserProfile({
    String? displayName,
    String? photoUrl,
    PhoneAuthCredential? phoneNumber,
    String? email,
    }) async {
    try {
      User? user = locator<FirebaseService>().firebaseAuth.currentUser;
      if(displayName != null) {
        await user?.updateDisplayName(displayName);
      }
      if(photoUrl != null) {
        await user?.updatePhotoURL(photoUrl);
      }
      if(phoneNumber != null) {
        await user?.updatePhoneNumber(phoneNumber);
      }

      if(email != null) {
        await user?.verifyBeforeUpdateEmail(email);
        toastMessage(message: "The email will be updated after it has been verified!");
      }
      
      return UserModel(
        id: user?.uid, 
        email: user?.email ?? "", 
        firstName: user?.displayName ?? "", 
        lastName: user?.displayName ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    }
  }

  @override
  Future<void> sendVerificationOTP({required String email}) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/resend-otp/",
        data: {
          "email": email,
        }
      );
      if(response.statusCode != 200) {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch(e) {
      throw APIException(message: e.message, statusCode: -1);
    }
  }

  @override
  Future<void> verifyUserEmail({required String email, required String otp}) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/validate-user/",
        data: {
          "email": email,
          "otp": otp,
        }
      );
      if(response.statusCode != 200) {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch(e) {
      throw APIException(message: e.message, statusCode: -1);
    }
  }

  @override
  Future<void> sendResetVerificationOTP({required String email}) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/password/reset/",
        data: {
          "email": email,
        }
      );
      if(response.statusCode != 200) {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch(e) {
      throw APIException(message: e.message, statusCode: -1);
    }
  }

  @override
  Future<void> verifyResetOTP({required String email, required String otp, required String password}) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/password/reset/verify/",
        data: {
          "username": email,
          "code": otp,
          "password": password,
        }
      );
      if(response.statusCode != 200) {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch(e) {
      throw APIException(message: e.message, statusCode: -1);
    }
  }

  @override
  Future<void> createPassword({required String password, required String confirmPassword}) async {
    try {
      final response = await _apiBaseHelper.postWithoutToken(
        "$baseUrl/password/change/",
        data: {
          "new_password": password,
          "old_password": confirmPassword,
        }
      );
      if(response.statusCode != 200) {
        throw APIException(message: response.body, statusCode: -1);
      }
    } on APIException catch(e) {
      throw APIException(message: e.message, statusCode: -1);
    }
  }
}