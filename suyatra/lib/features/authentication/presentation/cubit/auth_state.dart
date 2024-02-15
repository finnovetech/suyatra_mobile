
import 'package:equatable/equatable.dart';
import 'package:suyatra/core/app_status.dart';
import '../../domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? user;
  final AppStatus authStatus;
  const AuthState({this.user, this.authStatus = AppStatus.initial});

  AuthState copyWith({
    UserEntity? user,
    AppStatus? authStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
    );
  }

  @override
  List<Object?> get props => [user, authStatus];
}