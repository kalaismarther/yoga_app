import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/walkthrough/models/banner_model.dart';
import 'package:yoga_app/features/walkthrough/models/walkthrough_failure_model.dart';
import 'package:yoga_app/features/walkthrough/models/walkthrough_success_model.dart';
import 'package:yoga_app/features/walkthrough/repo/walk_through_api.dart';

part 'walk_through_event.dart';
part 'walk_through_state.dart';

class WalkThroughBloc extends Bloc<WalkThroughEvent, WalkThroughState> {
  WalkThroughBloc() : super(WalkThroughInitial()) {
    on<WalkThroughEvent>((event, emit) {});
    on<GetWalkThroughContentEvent>((event, emit) async {
      emit(WalkThroughLoadingState());

      final apiRequest = await WalkThroughApi.getBanners();

      if (apiRequest.success) {
        if (apiRequest.data['status']?.toString() == '1') {
          emit(
            WalkThroughSuccessState(
              data: WalkthroughSuccessModel(
                banners: [
                  for (var banner in apiRequest.data['data'] ?? [])
                    BannerModel(
                      imageLink: banner['is_image']?.toString() ?? '',
                      title: banner['title']?.toString() ?? '',
                      description: banner['walkthrough_desc']?.toString() ?? '',
                    )
                ],
              ),
            ),
          );
        } else {
          emit(
            WalkThroughFailureState(
              error: WalkthroughFailureModel(
                  reason: apiRequest.data['message'] ?? ''),
            ),
          );
        }
      } else {
        emit(
          WalkThroughFailureState(
            error:
                WalkthroughFailureModel(reason: apiRequest.errorMessage ?? ''),
          ),
        );
      }
    });
  }
}
