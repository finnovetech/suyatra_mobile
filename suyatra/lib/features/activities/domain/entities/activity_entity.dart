import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int id;
  final String activityName;

  const ActivityEntity({
    required this.id,
    required this.activityName,
  });

  @override
  List<Object> get props => [
    id,
    activityName,
  ];
}
