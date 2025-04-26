import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_request_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_success_model.dart';
import 'package:yoga_app/features/purchase/repo/purchase_api.dart';

part 'yoga_detail_event.dart';
part 'yoga_detail_state.dart';

class YogaDetailBloc extends Bloc<YogaDetailEvent, YogaDetailState> {
  YogaDetailBloc() : super(YogaDetailInitialState()) {
    on<GetYogaDetailEvent>((event, emit) async {
      emit(YogaDetailInitialState());
      final detail = await HiveServices.read('user_detail');
      final user = ProfileDetailModel.fromJson(detail);

      final apiResult = await PurchaseApi.getYogaDetail(
          input: YogaDetailRequestModel(
              userId: user.userId, courseId: event.courseId),
          token: user.apiToken);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          var yogaDetail = YogaDetailSuccessModel.fromJson(apiResult.data);
          emit(YogaDetailSuccessState(data: yogaDetail));
        } else if (apiResult.data['status'].toString() == '2') {
          emit(YogaDetailSessionExpiredState(
              error: apiResult.data['message'] ?? 'Session Expired'));
        } else {
          emit(YogaDetailFailureState(error: apiResult.data['message'] ?? ''));
        }
      } else {
        emit(YogaDetailFailureState(error: 'Something went wrong'));
      }
    });
  }
}
