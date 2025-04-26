import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/Notifications/models/notification_model.dart';
import 'package:yoga_app/features/Notifications/models/notification_request_model.dart';
import 'package:yoga_app/features/Notifications/repo/notification_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  int page = 0;

  void getNotifications() async {
    try {
      if (state is NotificationsLoading) return;
      final currentState = state;

      var oldNotifications = <NotificationModel>[];

      if (currentState is NotificationsLoadedState) {
        oldNotifications = currentState.notifications;
      }
      emit(NotificationsLoading(
          oldNotifications: oldNotifications, isFirstFetch: page == 0));

      final userDetail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(userDetail);

      var input = NotificationRequestModel(
          userId: user.userId, pageNo: page, apiToken: user.apiToken);

      final apiResult = await NotificationApi.getNotifications(input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1' ||
            (apiResult.data['status'].toString() == '0' &&
                apiResult.data['data']?.isEmpty == true)) {
          var userNotifications = [
            for (final notification in apiResult.data['data'] ?? [])
              NotificationModel.fromJson(notification)
          ];
          final notifications =
              (state as NotificationsLoading).oldNotifications;
          notifications.addAll(userNotifications);
          page = notifications.length;
          emit(NotificationsLoadedState(notifications: notifications));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(NotificationsExpiredState(
              error: apiResult.data['message'] ?? 'Session Expired'));
        } else {
          final notifications =
              (state as NotificationsLoading).oldNotifications;

          emit(NotificationsFailureState(
              error: apiResult.data['message'] ?? '',
              previousNotifications: notifications,
              isFirstFetch: page == 0));
        }
      } else {
        emit(NotificationsFailureState(
            error: apiResult.errorMessage ?? '', isFirstFetch: page == 0));
      }
    } catch (e) {
      //
    }
  }
}
