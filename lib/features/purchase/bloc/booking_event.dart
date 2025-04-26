part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class MakePaymentButtonClickedEvent extends BookingEvent {
  final int classId;
  final int durationId;
  final int timeslotId;
  final String startDate;
  final int isIos;

  MakePaymentButtonClickedEvent(
      {required this.classId,
      required this.durationId,
      required this.timeslotId,
      required this.startDate, required this.isIos});
}

class UpdatePaymentStatusEvent extends BookingEvent {
  final int bookingId;
  final String paymentId;
  final String paymentStatus;

  UpdatePaymentStatusEvent(
      {required this.bookingId,
      required this.paymentId,
      required this.paymentStatus});
}

class InAppPurchaseEvent extends BookingEvent {
  final String productId;

  InAppPurchaseEvent({required this.productId});
}

class PaymentSuccessEvent extends BookingEvent {}

class PaymentFailedEvent extends BookingEvent {}
