import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/HelpAndSupport/models/help_request_model.dart';
import 'package:yoga_app/features/HelpAndSupport/repo/help_and_support_api.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

part 'help_and_support_event.dart';
part 'help_and_support_state.dart';

class HelpAndSupportBloc
    extends Bloc<HelpAndSupportEvent, HelpAndSupportState> {
  HelpAndSupportBloc() : super(HelpAndSupportInitial()) {
    on<HelpAndSupportEvent>((event, emit) {});

    on<SendHelpRequestEvent>((event, emit) async {
      emit(HelpRequestLoadingState());

      final detail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(detail);

      var input = HelpRequestModel(
          userId: user.userId,
          messageType: event.title,
          description: event.comment,
          apiToken: user.apiToken);

      final apiResult = await HelpAndSupportApi.sendHelpRequest(input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          emit(HelpRequestSuccessState(
              message: apiResult.data['message'] ?? ''));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(HelpRequestExpiredState(
              error: apiResult.data['message'] ?? 'Session Expired'));
        } else {
          emit(HelpRequestFailureState(error: apiResult.data['message'] ?? ''));
        }
      } else {
        emit(HelpRequestFailureState(error: apiResult.errorMessage ?? ''));
      }
    });
  }
}
