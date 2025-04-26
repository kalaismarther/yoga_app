import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/dashboard/models/logout_failure_model.dart';
import 'package:yoga_app/features/dashboard/models/logout_request_model.dart';
import 'package:yoga_app/features/dashboard/models/logout_success_model.dart';
import 'package:yoga_app/features/dashboard/repo/dashboard_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<SideMenuButtonClickedEvent>((event, emit) {
      emit(SideMenuButtonClickedState());
    });
    on<NotificationButtonClickedEvent>((event, emit) {
      emit(NotificationButtonClickedState());
    });
    on<ShowLogoutAlertEvent>((event, emit) => emit(LogoutAlertState()));

    on<LogoutButtonClickedEvent>(_logout);
  }

  FutureOr<void> _logout(
      LogoutButtonClickedEvent event, Emitter<DashboardState> emit) async {
    emit(LogoutLoadingState());
    final detail = await HiveServices.read('user_detail');
    final user = ProfileDetailModel.fromJson(detail);
    var input = LogoutRequestModel(
        userId: user.userId,
        fcmToken: "fdjdl",
        deviceId: "user.deviceId",
        deviceType: "user.deviceType",
        apiToken: user.apiToken);
    final apiResult = await DashboardApi.logoutUser(input);

    if (apiResult.success) {
      if (apiResult.data['status'].toString() == '1') {
        emit(LogoutSuccessState(
            data:
                LogoutSuccessModel(message: apiResult.data['message'] ?? '')));
      } else if (apiResult.data['status'].toString() == '2') {
        emit(LogoutExpiredState(
            error: apiResult.data['message']?.toString() ?? 'Session Expired'));
      }
    } else {
      emit(LogoutFailureState(
          error: LogoutFailureModel(reason: apiResult.errorMessage!)));
    }
  }
}
