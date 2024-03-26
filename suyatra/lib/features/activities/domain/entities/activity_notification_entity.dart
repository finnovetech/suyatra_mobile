import 'package:equatable/equatable.dart';

class ActivityNotificationEntity extends Equatable {
  final int id;
  final String title;
  final DateTime createdAt;

  const ActivityNotificationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    title,
    createdAt,
  ];
}
