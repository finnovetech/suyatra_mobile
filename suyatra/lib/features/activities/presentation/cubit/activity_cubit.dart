import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_status.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/activity_notification_entity.dart';

part 'activity_state.dart';
class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(const ActivityState());
}