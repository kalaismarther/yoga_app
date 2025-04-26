part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class SideMenuButtonClickedState extends DashboardState {}

final class NotificationButtonClickedState extends DashboardState {}

final class LogoutAlertState extends DashboardState {}

final class LogoutLoadingState extends DashboardState {}

final class LogoutSuccessState extends DashboardState {
  final LogoutSuccessModel data;

  LogoutSuccessState({required this.data});
}

final class LogoutFailureState extends DashboardState {
  final LogoutFailureModel error;

  LogoutFailureState({required this.error});
}

final class LogoutExpiredState extends DashboardState {
  final String error;

  LogoutExpiredState({required this.error});
}
