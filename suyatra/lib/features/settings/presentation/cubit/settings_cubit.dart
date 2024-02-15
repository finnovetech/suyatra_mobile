import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/features/settings/presentation/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());
}