import 'dart:convert';

import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
  });

  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(jsonDecode(source));
  }

  UserModel.fromMap(DataMap map)
    : this(
      id: map["id"],
      email: map["email"],
      firstName: map["first_name"],
      lastName: map["last_name"],
    );

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      id: id ?? this.id, 
      email: email ?? this.email, 
      firstName: firstName ?? this.firstName, 
      lastName: lastName ?? this.lastName,
    );
  }

  DataMap toMap() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
  };

  String toJson() => jsonEncode(toMap());
}