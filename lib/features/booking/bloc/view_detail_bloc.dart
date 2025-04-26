import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/booking/models/view_detail_failure_model.dart';
import 'package:yoga_app/features/booking/models/view_detail_request_model.dart';
import 'package:yoga_app/features/booking/models/view_detail_success_model.dart';
import 'package:yoga_app/features/booking/repo/my_booking_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
part 'view_detail_event.dart';
part 'view_detail_state.dart';

class ViewDetailBloc extends Bloc<ViewDetailEvent, ViewDetailState> {
  ViewDetailBloc() : super(ViewDetailInitial()) {
    on<ViewDetailEvent>((event, emit) {});

    on<GetBookingDetailEvent>((event, emit) async {
      try {
        emit(ViewDetailLoadingState());

        final detail = await HiveServices.read('user_detail');

        final user = ProfileDetailModel.fromJson(detail);

        var input = ViewDetailRequestModel(
            userId: user.userId,
            bookingId: event.bookingId,
            apiToken: user.apiToken);

        final apiResult = await MyBookingApi.getDetail(input: input);

        print(apiResult.data);

        if (apiResult.success) {
          if (apiResult.data['status'].toString() == '1') {
            emit(ViewDetailSuccessState(
                data: ViewDetailSuccessModel.fromJson(apiResult.data)));
          } else if (apiResult.data['status'].toString() == '2') {
            emit(ViewDetailExpiredState(
                error: apiResult.data['message'] ?? 'Session Expired'));
          } else {
            emit(ViewDetailFailureState(
                error: ViewDetailFailureModel(
                    reason: apiResult.data['message'] ?? '')));
          }
        } else {
          emit(ViewDetailFailureState(
              error: ViewDetailFailureModel(
                  reason: apiResult.errorMessage ?? '')));
        }
      } catch (e) {
        emit(ViewDetailFailureState(
            error: ViewDetailFailureModel(reason: e.toString())));
      }
    });
  }
}
