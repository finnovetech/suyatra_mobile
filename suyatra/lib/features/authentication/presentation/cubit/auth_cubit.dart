import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/domain/usecases/create_password_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_in_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/sign_out_user_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/update_user_profile_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/verify_reset_otp_use_case.dart';
import 'package:suyatra/features/authentication/domain/usecases/verify_user_email_use_case.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_state.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';

import '../../../../utils/toast_message.dart';
import '../../domain/usecases/send_reset_verification_otp_use_case.dart';
import '../../domain/usecases/send_verification_otp_use_case.dart';
import '../../domain/usecases/sign_in_with_google_use_case.dart';
import '../../domain/usecases/sign_up_user_use_case.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpUserUseCase signUpUserUseCase;
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final SendVerificationOTPUseCase sendVertificationOTPUseCase;
  final VerifyUserEmailUseCase verifyUserEmailUseCase;
  final SendResetVerificationOTPUseCase sendResetVerificationOTPUseCase;
  final VerifyResetOTPUseCase verifyResetOTPUseCase;
  final CreatePasswordUseCase createPasswordUseCase;

  AuthCubit({
    required this.signUpUserUseCase, 
    required this.signInUserUseCase, 
    required this.signOutUserUseCase,
    required this.signInWithGoogleUseCase,
    required this.updateUserProfileUseCase,
    required this.sendVertificationOTPUseCase,
    required this.verifyUserEmailUseCase,
    required this.sendResetVerificationOTPUseCase,
    required this.verifyResetOTPUseCase,
    required this.createPasswordUseCase,
  }) 
    : super(const AuthState());

  signUpUser({
    required String email,
    required String password,
    required String fullName,
    }) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await signUpUserUseCase.call(
        SignUpUserParams(email: email, password: password, fullName: fullName)
      );
      
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(user: data, userEmail: email, userFullName: fullName, userPassword: password, authStatus: AppStatus.success));
          sendVerificationOTP();  
        }

      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  signInUser({
    required String email,
    required String password,
    }) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await signInUserUseCase.call(
        SignInUserParams(email: email, password: password)
      );
      
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) => emit(state.copyWith(user: data, authStatus: AppStatus.success))
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  signOutUser() async {
    try {
      final result = await signOutUserUseCase.call();

      result.fold(
        (error) => emit(state.copyWith(authStatus: AppStatus.failure)), 
        (data) {
          emit(state.copyWith(authStatus: AppStatus.success, user: null));
          locator<NavigationService>().navigateToAndRemoveAll(splashRoute);
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  signInWithGoogle() async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await signInWithGoogleUseCase.call();

      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) => emit(state.copyWith(user: data, authStatus: AppStatus.success))
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e);
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  updateUserProfile({
    String? displayName,
    String? photoUrl,
    PhoneAuthCredential? phoneNumber,
    String? email,
    }) async {
    if(state.authStatus == AppStatus.loading) {
      return;
    }
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await updateUserProfileUseCase.call(
        UpdateUserProfileParams(displayName: displayName, photoUrl: photoUrl, phoneNumber: phoneNumber, email: email),
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(user: data, authStatus: AppStatus.success));
          toastMessage(message: "Profile has been updated!");
          locator<NavigationService>().goBack();
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  sendVerificationOTP() async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await sendVertificationOTPUseCase.call(
        SendVerificationOTPParams(
          email: state.userEmail!,
        )
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(authStatus: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  verifyUserEmail({required String otp}) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await verifyUserEmailUseCase.call(
        VerifyUserEmailParams(
          email: state.userEmail!,
          otp: otp
        )
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(authStatus: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  sendResetVerificationOTP({required String email}) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await sendResetVerificationOTPUseCase.call(
        SendResetVerificationOTPParams(
          email: email,
        )
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(userEmail: email, authStatus: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  verifyResetOTP({required String otp}) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await verifyResetOTPUseCase.call(
        VerifyResetOTPParams(
          email: state.userEmail!,
          otp: otp,
          password: state.userPassword!,
        )
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(authStatus: AppStatus.success));
          locator<NavigationService>().navigateToAndBack(createPasswordRoute);
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }

  createPassword({required String password, required String confirmPassword}) async {
    emit(state.copyWith(authStatus: AppStatus.loading));
    try {
      final result = await createPasswordUseCase.call(
        CreatePasswordParams(
          password: password, 
          confirmPassword: confirmPassword,
        )
      );
      result.fold(
        (error) {
          emit(state.copyWith(authStatus: AppStatus.failure));
          toastMessage(message: error.message);
        }, 
        (data) {
          emit(state.copyWith(authStatus: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(authStatus: AppStatus.failure));
    }
  }
}