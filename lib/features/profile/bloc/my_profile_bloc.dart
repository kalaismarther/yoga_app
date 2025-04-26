import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/profile/models/edit_profile_failure_model.dart';
import 'package:yoga_app/features/profile/models/edit_profile_request_model.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/profile/models/profile_image_request_model.dart';
import 'package:yoga_app/features/profile/repo/profile_api.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  MyProfileBloc() : super(MyProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileDetailLoadingState());
      final userDetail = await HiveServices.read('user_detail');
      final showDeleteIcon = await ProfileApi.showDeleteIcon();
      try {
        if (showDeleteIcon.success) {
          if (showDeleteIcon.data['status']?.toString().trim() == '1') {
            await HiveServices.write('delete_btn', true);
          } else {
            await HiveServices.write('delete_btn', false);
          }
        } else {
          await HiveServices.write('delete_btn', true);
        }
      } catch (e) {
        await HiveServices.write('delete_btn', true);
      }

      final deleteBtnAvailable = await HiveServices.read('delete_btn');

      emit(ProfileDetailState(
          showDeleteIcon: deleteBtnAvailable?.toString() == 'true',
          profileData: ProfileDetailModel.fromJson(userDetail)));
    });

    on<SaveChagesButtonClickedEvent>((event, emit) async {
      emit(EditProfileLoadingState());

      final apiResult = await ProfileApi.editUserProfile(event.input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          await HiveServices.write('user_detail', apiResult.data['data'] ?? {});
          emit(EditProfileSuccessState(
            message: apiResult.data['message'] ?? '',
          ));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(SessionExpiredState(
            reason: apiResult.data['message'] ?? 'Session expired',
          ));
        } else if (apiResult.data['status'].toString() == '3') {
          emit(MobileNumberChangedState());
        } else {
          emit(EditProfileFailureState(
            reason:
                EditProfileFailureModel(error: apiResult.data['message'] ?? ''),
          ));
        }
      } else {
        emit(EditProfileFailureState(
          reason: EditProfileFailureModel(error: apiResult.errorMessage!),
        ));
      }
    });

    on<CameraIconClickedEvent>((event, emit) {
      emit(CameraIconClickedState());
    });

    on<UpdateProfileImageEvent>((event, emit) async {
      emit(EditProfileLoadingState());
      final userDetail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(userDetail);
      final input = ProfileImageRequestModel(
          userId: user.userId,
          imagePath: event.imagePath,
          apiToken: user.apiToken);

      final apiResult = await ProfileApi.updateUserProfileImage(input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          await HiveServices.write('user_detail', apiResult.data['data'] ?? {});
          emit(UpdateProfileImageSuccessState(
              successMessage: apiResult.data['message'] ?? ''));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(SessionExpiredState(
              reason: apiResult.data['message'] ?? 'Session expired'));
        } else {
          emit(UpdateProfileImageFailureState(
              failureMessage: apiResult.data['message'] ?? ''));
        }
      } else {
        emit(UpdateProfileImageFailureState(
            failureMessage: apiResult.errorMessage ?? ''));
      }
    });
  }
}
