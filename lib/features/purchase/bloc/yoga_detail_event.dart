part of 'yoga_detail_bloc.dart';

@immutable
sealed class YogaDetailEvent {}

class GetYogaDetailEvent extends YogaDetailEvent {
  final int courseId;

  GetYogaDetailEvent({required this.courseId});
}

class YogaDetailSuccessEvent extends YogaDetailEvent {}

class YogaDetailFailureEvent extends YogaDetailEvent {}
