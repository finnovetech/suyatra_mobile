import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  const UserEntity({this.id, this.email, this.firstName, this.lastName});

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}