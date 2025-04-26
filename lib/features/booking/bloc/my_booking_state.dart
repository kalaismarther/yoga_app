part of 'my_booking_bloc.dart';

@immutable
sealed class MyBookingState {}

final class MyBookingInitial extends MyBookingState {}

final class MyBookingsListLoadingState extends MyBookingState {}

final class MyBookingsListSuccessState extends MyBookingState {
  final MyBookingSuccessModel data;

  MyBookingsListSuccessState({required this.data});
}

final class MyBookingsListFailureState extends MyBookingState {
  final MyBookingFailureModel error;

  MyBookingsListFailureState({required this.error});
}

final class MyBookingExpiredState extends MyBookingState {
  final String error;
  MyBookingExpiredState({required this.error});
}
