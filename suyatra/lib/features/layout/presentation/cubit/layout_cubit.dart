import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/utils/toast_message.dart';

import '../../../../core/app_status.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState());

  changeBottomIndex(int index) {
    emit(state.copyWith(layoutStatus: AppStatus.loading));
    try {
      emit(state.copyWith(currentIndex: index, layoutStatus: AppStatus.success));
    } catch(e) {
      if(kDebugMode) {
        print(e);
      }
      toastMessage(message: e);
      emit(state.copyWith(layoutStatus: AppStatus.failure));
    }
  }
}