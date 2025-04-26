part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationsLoading extends NotificationState {
  final List<NotificationModel> oldNotifications;
  final bool isFirstFetch;

  NotificationsLoading(
      {required this.oldNotifications, this.isFirstFetch = false});
}

final class NotificationsLoadedState extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationsLoadedState({required this.notifications});
}

class NotificationsFailureState extends NotificationState {
  final String error;
  final List<NotificationModel>? previousNotifications;
  final bool isFirstFetch;

  NotificationsFailureState(
      {required this.error,
      this.previousNotifications,
      this.isFirstFetch = false});
}

final class NotificationsExpiredState extends NotificationsFailureState {
  NotificationsExpiredState({required super.error});
}
