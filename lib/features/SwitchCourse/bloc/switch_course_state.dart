part of 'switch_course_bloc.dart';

@immutable
sealed class SwitchCourseState {}

final class SwitchCourseInitial extends SwitchCourseState {}

class SwitchCourseLoadingState extends SwitchCourseState {}

class SwitchCourseSuccessState extends SwitchCourseState {
  final SwitchCourseSuccessModel data;

  SwitchCourseSuccessState({required this.data});
}

class SwitchCourseFailureState extends SwitchCourseState {
  final SwitchCourseFailureModel error;

  SwitchCourseFailureState({required this.error});
}
