import 'dart:convert';

import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.uid,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.contactNumber,
    required super.profileUrl,
    required super.isActive,
    required super.dateJoined,
    required super.refresh,
    required super.access,
  });

  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(jsonDecode(source));
  }

  UserModel.fromMap(DataMap map)
    : this(
      id: map["user"]["id"],
      uid: map["user"]["uid"],
      firstName: map["user"]["first_name"],
      lastName: map["user"]["last_name"],
      email: map["user"]["email"],
      profileUrl: map["profile"]["profile_image"],
      contactNumber: map["user"]["contact_number"],
      isActive: map["user"]["is_active"],
      dateJoined: map["user"]["date_joined"],
      refresh: map["refresh"],
      access: map["access"],
    );

  // UserModel copyWith({
  //   String? id,
  //   String? uid,
  //   String? email,
  //   String? firstName,
  //   String? lastName,
  // }) {
  //   return UserModel(
  //     id: id ?? this.id, 
  //     uid: uid ?? this.uid,
  //     email: email ?? this.email, 
  //     firstName: firstName ?? this.firstName, 
  //     lastName: lastName ?? this.lastName,
  //   );
  // }

  // DataMap toMap() => {
  //   "id": id,
  //   "email": email,
  //   "first_name": firstName,
  //   "last_name": lastName,
  // };

  // String toJson() => jsonEncode(toMap());
}