part of 'my_booking_bloc.dart';

@immutable
sealed class MyBookingEvent {}

class GetMyBookingsEvent extends MyBookingEvent {
  final int type;

  GetMyBookingsEvent({required this.type});
}
