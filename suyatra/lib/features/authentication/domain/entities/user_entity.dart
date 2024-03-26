import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? contactNumber;
  final bool isActive;
  final String? dateJoined;
  final String? profileUrl;
  final String? refresh;
  final String? access;
  final bool isPremium;
  const UserEntity({
    this.id,
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.profileUrl,
    this.isPremium = false,
    this.contactNumber,
    this.isActive = true,
    this.dateJoined,
    this.refresh,
    this.access,
  });

  @override
  List<Object?> get props {
    return [
      id,
      uid,
      email,
      firstName,
      lastName,
      contactNumber,
      isActive,
      dateJoined,
      profileUrl,
      refresh,
      access,
      isPremium,
    ];
  }
}
