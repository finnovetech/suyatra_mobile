part of 'account_cubit.dart';

class AccountState extends Equatable {
  final AppStatus accountStatus;

  const AccountState({
    this.accountStatus = AppStatus.initial,
  });

  AccountState copyWith({
    AppStatus? accountStatus,
  }) {
    return AccountState(
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }

  @override
  List<Object?> get props => [
    accountStatus,
  ];
}