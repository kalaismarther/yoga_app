part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class SideMenuButtonClickedEvent extends DashboardEvent {}

class NotificationButtonClickedEvent extends DashboardEvent {}

class ShowLogoutAlertEvent extends DashboardEvent {}

class LogoutButtonClickedEvent extends DashboardEvent {}
