part of 'activity_cubit.dart';

class ActivityState extends Equatable {
  final AppStatus accountStatus;
  final List<ActivityEntity>? activities;
  final List<ActivityNotificationEntity>? activityNotifications;

  const ActivityState({
    this.accountStatus = AppStatus.initial,
    this.activities,
    this.activityNotifications,
  });

  ActivityState copyWith({
    AppStatus? accountStatus,
    List<ActivityEntity>? activities,
    List<ActivityNotificationEntity>? activityNotifications,
  }) {
    return ActivityState(
      accountStatus: accountStatus ?? this.accountStatus,
      activities: activities ?? this.activities,
      activityNotifications: activityNotifications ?? this.activityNotifications,
    );
  }

  @override
  List<Object?> get props => [
    accountStatus,
    activities,
    activityNotifications,
  ];
}