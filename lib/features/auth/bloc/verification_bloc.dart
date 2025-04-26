import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/device_helper.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/Services/pref_service.dart';
import 'package:yoga_app/features/Auth/models/resend_failure_model.dart';
import 'package:yoga_app/features/Auth/models/resend_request_model.dart';
import 'package:yoga_app/features/Auth/models/resend_success_model.dart';
import 'package:yoga_app/features/Auth/models/verification_failure_model.dart';
import 'package:yoga_app/features/Auth/models/verification_request_model.dart';
import 'package:yoga_app/features/Auth/models/verification_success_model.dart';
import 'package:yoga_app/features/Auth/repo/auth_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    on<VerificationButtonPressedEvent>(_verifyOtp);
    on<ResendButtonPressedEvent>(_resendOtp);
  }

  FutureOr<void> _verifyOtp(VerificationButtonPressedEvent event,
      Emitter<VerificationState> emit) async {
    emit(VerificationLoadingState());

    final detail = await HiveServices.read('user_detail');
    final user = ProfileDetailModel.fromJson(detail ?? {});

    final device = await DeviceHelper.getDeviceInfo();
    final fcmToken = await DeviceHelper.getFCM();
    //
    var input = VerificationRequestModel(
      mobileNo: event.mobNo,
      otp: event.otp,
      deviceType: device.type,
      deviceId: device.id,
      fcmToken: fcmToken,
      userId: event.forLogin ? null : user.userId,
    );

    final apiResult = event.forLogin
        ? await AuthApi.userVerification(input)
        : await AuthApi.verifyOtpEdit(input, user.apiToken);

    if (apiResult.success) {
      if (apiResult.data['status'].toString() == '1') {
        var verifiedData = VerificationSuccessModel.fromJson(apiResult.data);

        if (verifiedData.userData.isProfileUpdated == 1) {
          await PrefService.writeBool('logged', true);
          await HiveServices.write('user_detail', apiResult.data['data'] ?? {});

          emit(ExistingUserState(data: verifiedData));
        } else {
          emit(NewUserState(data: verifiedData));
        }
      } else {
        emit(VerificationFailureState(
            reason: VerificationFailureModel(
                error: apiResult.data['message'] ?? '')));
      }
    } else {
      emit(VerificationFailureState(
          reason: VerificationFailureModel(error: apiResult.errorMessage!)));
    }
  }

  FutureOr<void> _resendOtp(
      ResendButtonPressedEvent event, Emitter<VerificationState> emit) async {
    emit(VerificationLoadingState());

    final apiResult = await AuthApi.resendOtp(
        ResendRequestModel(userId: 0, mobileNo: event.mobileNo));

    if (apiResult.success) {
      if (apiResult.data['status'].toString() == '1') {
        emit(ResendOtpSuccessState(
            data:
                ResendSuccessModel(message: apiResult.data['message'] ?? '')));
      } else {
        emit(ResendOtpFailureState(
            error:
                ResendFailureModel(reason: apiResult.data['message'] ?? '')));
      }
    } else {
      emit(ResendOtpFailureState(
          error: ResendFailureModel(reason: apiResult.errorMessage!)));
    }
  }
}
