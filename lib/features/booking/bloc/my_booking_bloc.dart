import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/booking/models/my_booking_failure_model.dart';
import 'package:yoga_app/features/booking/models/my_booking_request_model.dart';
import 'package:yoga_app/features/booking/models/my_booking_success_model.dart';
import 'package:yoga_app/features/booking/repo/my_booking_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
part 'my_booking_event.dart';
part 'my_booking_state.dart';

class MyBookingBloc extends Bloc<MyBookingEvent, MyBookingState> {
  MyBookingBloc() : super(MyBookingInitial()) {
    on<MyBookingEvent>((event, emit) {});

    on<GetMyBookingsEvent>((event, emit) async {
      try {
        emit(MyBookingsListLoadingState());

        final detail = await HiveServices.read('user_detail');

        final user = ProfileDetailModel.fromJson(detail);

        var input = MyBookingRequestModel(
            userId: user.userId, type: event.type, apiToken: user.apiToken);

        final apiResult = await MyBookingApi.getMyBookingsList(input: input);

        if (apiResult.success) {
          if (apiResult.data['status'].toString() == '1') {
            emit(MyBookingsListSuccessState(
                data: MyBookingSuccessModel.fromJson(
                    apiResult.data['data'] ?? '')));
          } else if (apiResult.data['status'].toString() == '2') {
            emit(MyBookingExpiredState(
                error: apiResult.data['message'] ?? 'Session Expired'));
          } else {
            emit(MyBookingsListFailureState(
                error: MyBookingFailureModel(
                    reason: apiResult.data['message'] ?? '')));
          }
        } else {
          emit(MyBookingsListFailureState(
              error:
                  MyBookingFailureModel(reason: apiResult.errorMessage ?? '')));
        }
      } catch (e) {
        emit(MyBookingsListFailureState(
            error: MyBookingFailureModel(reason: e.toString())));
      }
    });
  }
}
