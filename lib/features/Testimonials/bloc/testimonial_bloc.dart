import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/Testimonials/models/testimonial_model.dart';
import 'package:yoga_app/features/Testimonials/repo/testimonial_api.dart';

part 'testimonial_event.dart';
part 'testimonial_state.dart';

class TestimonialBloc extends Bloc<TestimonialEvent, TestimonialState> {
  TestimonialBloc() : super(TestimonialInitial()) {
    on<TestimonialEvent>((event, emit) {});

    on<GetTestimonialsEvent>((event, emit) async {
      emit(TestimonialLoadingState());

      final apiRequest = await TestimonialApi.getTestimonials();

      if (apiRequest.success) {
        if (apiRequest.data['status']?.toString() == '1') {
          emit(TestimonialSuccessState(testimonials: [
            for (var testimonial in apiRequest.data['data'] ?? [])
              TestimonialModel.fromJson(testimonial)
          ]));
        } else if (apiRequest.data['status']?.toString() == '2') {
          emit(
              TestimonialExpiredState(error: apiRequest.data['message'] ?? ''));
        } else {
          emit(
              TestimonialFailureState(error: apiRequest.data['message'] ?? ''));
        }
      } else {
        emit(TestimonialFailureState(error: apiRequest.errorMessage ?? ''));
      }
    });
  }
}
