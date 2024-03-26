import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileUrl;
  final bool isPremium;
  const UserEntity({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileUrl,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    profileUrl,
    isPremium,
  ];
}
