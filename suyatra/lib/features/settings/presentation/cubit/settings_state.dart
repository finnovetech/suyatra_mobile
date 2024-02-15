import 'package:equatable/equatable.dart';
import 'package:suyatra/core/app_status.dart';

class SettingsState extends Equatable {
  final AppStatus appStatus;

  const SettingsState({
    this.appStatus = AppStatus.initial,
  });

  @override
  List<Object?> get props => [
    appStatus,
  ];
}