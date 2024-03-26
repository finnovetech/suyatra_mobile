part of 'layout_cubit.dart';

class LayoutState extends Equatable {
  final AppStatus layoutStatus;
  final int currentIndex;

  const LayoutState({ 
    this.layoutStatus = AppStatus.initial, 
    this.currentIndex = 0,
  });

  LayoutState copyWith({
    AppStatus? layoutStatus,
    int? currentIndex,
  }) {
    return LayoutState(
      layoutStatus: layoutStatus ?? this.layoutStatus,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
    layoutStatus,
    currentIndex,
  ];
}