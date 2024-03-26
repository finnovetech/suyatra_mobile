part of 'home_cubit.dart';

class HomeState extends Equatable {
  final AppStatus homeStatus;

  const HomeState({
    this.homeStatus = AppStatus.initial,
  });

  HomeState copyWith({
    AppStatus? homeStatus,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
    );
  }

  @override
  List<Object?> get props => [
    homeStatus,
  ];
}