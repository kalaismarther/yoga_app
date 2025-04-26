part of 'testimonial_bloc.dart';

@immutable
sealed class TestimonialState {}

final class TestimonialInitial extends TestimonialState {}

final class TestimonialLoadingState extends TestimonialState {}

final class TestimonialSuccessState extends TestimonialState {
  final List<TestimonialModel> testimonials;

  TestimonialSuccessState({required this.testimonials});
}

final class TestimonialFailureState extends TestimonialState {
  final String error;

  TestimonialFailureState({required this.error});
}

final class TestimonialExpiredState extends TestimonialFailureState {
  TestimonialExpiredState({required super.error});
}
