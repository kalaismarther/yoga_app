import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/Services/pref_service.dart';
import 'package:yoga_app/features/profile/models/update_profile_failure_model.dart';
import 'package:yoga_app/features/profile/models/update_profile_request_model.dart';
import 'package:yoga_app/features/profile/models/update_profile_success_model.dart';
import 'package:yoga_app/features/profile/repo/profile_api.dart';
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateProfileButtonPressedEvent>((event, emit) async {
      try {
        emit(UpdateProfileLoadingState());

        final apiResult = await ProfileApi.updateUserProfile(event.input);

        print(apiResult.data);

        if (apiResult.success) {
          if (apiResult.data['status']?.toString() == '4') {
            emit(UpdateProfileSuccessState(
                redirectToHomePage: true,
                data: UpdateProfileSuccessModel.fromJson(apiResult.data)));
          }
          if (apiResult.data['status']?.toString() == '1') {
            await PrefService.writeBool('logged', true);

            await HiveServices.write(
                'user_detail', apiResult.data['data'] ?? {});
            emit(UpdateProfileSuccessState(
                data: UpdateProfileSuccessModel.fromJson(apiResult.data)));
          } else if (apiResult.data['status']?.toString() == '2') {
            emit(UpdateProfileExpiredState(
                reason: UpdateProfileFailureModel(
              error: apiResult.data['message'] ?? 'Session expired',
            )));
          } else {
            emit(UpdateProfileFailureState(
                reason: UpdateProfileFailureModel(
                    error: apiResult.data['message'] ?? '')));
          }
        } else {
          emit(UpdateProfileFailureState(
              reason:
                  UpdateProfileFailureModel(error: apiResult.errorMessage!)));
        }
      } catch (e) {
        emit(UpdateProfileFailureState(
            reason: UpdateProfileFailureModel(error: e.toString())));
      }
    });
  }
}
