part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

final class BookingLoadingState extends BookingState {}

final class BookingSuccessState extends BookingState {
  final BookingSuccessModel data;

  BookingSuccessState({required this.data});
}

class BookingFailureState extends BookingState {
  final BookingFailureModel error;

  BookingFailureState({required this.error});
}

class BookingExpiredState extends BookingState {
  final String error;
  BookingExpiredState({required this.error});
}

class PaymentLoadingState extends BookingState {}

class PaymentSuccessState extends BookingState {}

class PaymentFailedState extends BookingState {}

class PaymentExpiredState extends BookingExpiredState {
  PaymentExpiredState({required super.error});
}

class InAppPurchaseState extends BookingState{}

class InAppPurchaseSuccess extends InAppPurchaseState {}

class InAppPurchaseFailure extends InAppPurchaseState {
  final String error;

  InAppPurchaseFailure({required this.error});
  
}
