import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/Services/network_services.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/search/models/search_failure_model.dart';
import 'package:yoga_app/features/search/models/search_request_model.dart';
import 'package:yoga_app/features/search/models/search_success_model.dart';
import 'package:yoga_app/features/search/repo/search_api.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) {});
    on<SearchYogaEvent>((event, emit) async {
      emit(SearchLoadingState());
      bool hasInternet = await NetworkServices.hasInternetConnection();
      if (hasInternet) {
        final userDetail = await HiveServices.read('user_detail');

        final user = ProfileDetailModel.fromJson(userDetail);

        var input = SearchRequestModel(
            userId: user.userId,
            keyword: event.keyword,
            apiToken: user.apiToken);

        final apiResult = await SearchApi.searchYoga(input);

        if (apiResult.success) {
          if (apiResult.data['status'].toString() == '1') {
            emit(SearchSuccessState(
                data: SearchSuccessModel(
                    yogaList: apiResult.data['data'] ?? [])));
          } else if (apiResult.data['status'].toString() == '2') {
            emit(SearchExpiredState(
                error: apiResult.data['message'] ?? 'Session Expired'));
          } else {
            emit(SearchFailureState(
                error: SearchFailureModel(
                    reason: apiResult.data['message'] ?? '')));
          }
        } else {
          emit(SearchFailureState(
              error: SearchFailureModel(
                  reason: apiResult.errorMessage ?? 'Session Expired')));
        }
      } else {
        emit(SearchNetworkErrorState());
      }
    });
    on<SearchYogaItemClickedEvent>((event, emit) {
      emit(SearchYogaItemClickedState());
    });
  }
}
