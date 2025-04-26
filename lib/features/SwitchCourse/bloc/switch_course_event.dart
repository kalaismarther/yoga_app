part of 'switch_course_bloc.dart';

@immutable
sealed class SwitchCourseEvent {}

class SendRequestButtonClickedEvent extends SwitchCourseEvent {
  final int bookingId;
  final int newClassId;
  final int timeSlotId;

  SendRequestButtonClickedEvent(
      {required this.bookingId,
      required this.newClassId,
      required this.timeSlotId});
}
