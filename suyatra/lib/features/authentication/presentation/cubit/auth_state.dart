
import 'package:equatable/equatable.dart';
import 'package:suyatra/core/app_status.dart';
import '../../domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? user;
  final AppStatus authStatus;
  final String? userEmail;
  final String? userPassword;
  final String? userFullName;
  const AuthState({this.user, this.authStatus = AppStatus.initial, this.userEmail, this.userPassword, this.userFullName,});

  AuthState copyWith({
    UserEntity? user,
    AppStatus? authStatus,
    String? userEmail,
    String? userPassword,
    String? userFullName,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      userEmail: userEmail ?? this.userEmail,
      userFullName: userFullName ?? this.userFullName,
      userPassword: userPassword ?? this.userPassword,
    );
  }

  @override
  List<Object?> get props => [user, authStatus, userEmail, userFullName, userPassword,];
}