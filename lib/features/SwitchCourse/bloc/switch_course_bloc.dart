import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/SwitchCourse/models/switch_course_failure_model.dart';
import 'package:yoga_app/features/SwitchCourse/models/switch_course_request_model.dart';
import 'package:yoga_app/features/SwitchCourse/models/switch_course_success_model.dart';
import 'package:yoga_app/features/SwitchCourse/repo/switch_course_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

part 'switch_course_event.dart';
part 'switch_course_state.dart';

class SwitchCourseBloc extends Bloc<SwitchCourseEvent, SwitchCourseState> {
  SwitchCourseBloc() : super(SwitchCourseInitial()) {
    on<SwitchCourseEvent>((event, emit) {});

    on<SendRequestButtonClickedEvent>((event, emit) async {
      emit(SwitchCourseLoadingState());
      final userDetail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(userDetail);

      var input = SwitchCourseRequestModel(
          userId: user.userId,
          bookingId: event.bookingId,
          newClassId: event.newClassId,
          timeSlotId: event.timeSlotId,
          apiToken: user.apiToken);

      final apiResult = await SwitchCourseApi.searchYoga(input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          emit(SwitchCourseSuccessState(
              data: SwitchCourseSuccessModel(
                  message: apiResult.data['message'] ?? '')));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(SwitchCourseSuccessState(
              data: SwitchCourseSuccessModel(
                  message: apiResult.data['message'] ?? '')));
        } else if (apiResult.data['status'].toString() == '3') {
          emit(SwitchCourseSuccessState(
              data: SwitchCourseSuccessModel(
                  message: apiResult.data['message'] ?? '')));
        } else {
          emit(SwitchCourseFailureState(
              error: SwitchCourseFailureModel(
                  reason: apiResult.data['message'] ?? '')));
        }
      } else {
        emit(SwitchCourseFailureState(
            error: SwitchCourseFailureModel(
                reason: apiResult.errorMessage ?? '')));
      }
    });
  }
}
