import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
// import 'package:yoga_app/Services/network_services.dart';
import 'package:yoga_app/features/home/models/home_failure_model.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/home/models/home_request_model.dart';
import 'package:yoga_app/features/home/models/home_success_model.dart';
import 'package:yoga_app/features/home/repo/home_api.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitialEvent>(
      (event, emit) async {
        emit(HomeInitialState());
        // bool hasInternet = await NetworkServices.hasInternetConnection();

        // if (hasInternet) {
        final userDetail = await HiveServices.read('user_detail');

        final user = ProfileDetailModel.fromJson(userDetail);

        final apiResult = await HomeApi.getYogaCourses(
            HomeRequestModel(userId: user.userId, apiToken: user.apiToken));

        if (apiResult.success) {
          if (apiResult.data['status'].toString() == '1') {
            await HiveServices.write(
                'owner_details', apiResult.data['support'] ?? {});
            emit(HomeSuccessState(
                data: HomeSuccessModel(
                    userName: user.name,
                    yogaCoursesList: apiResult.data['data'] ?? [])));
          } else if (apiResult.data['status'].toString() == '2') {
            emit(HomeExpiredState(
                error: apiResult.data['message'] ?? 'Session Expired'));
          } else {
            emit(HomeFailureState(
                error:
                    HomeFailureModel(reason: apiResult.data['message'] ?? '')));
          }
        } else {
          emit(HomeFailureState(
              error: HomeFailureModel(reason: apiResult.errorMessage ?? '')));
        }
        // } else {
        //   emit(HomeNetworkErrorState());
        // }
      },
    );

    on<YogaItemClickedEvent>((event, emit) => emit(YogaItemClickedState()));
  }
}
