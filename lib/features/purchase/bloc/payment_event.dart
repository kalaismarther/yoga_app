part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class InitiatePaymentEvent extends PaymentEvent {
  final int orderId;
  final String orderRefNo;
  final double amount;

  InitiatePaymentEvent({
    required this.orderId,
    required this.amount,
    required this.orderRefNo,
  });
}

class PaymentSuccessEvent extends PaymentEvent {
  final String paymentId;
  PaymentSuccessEvent(this.paymentId);
}

class PaymentFailureEvent extends PaymentEvent {
  final String reason;
  PaymentFailureEvent(this.reason);
}

class UpdatePaymentEvent extends PaymentEvent {
  final int orderId;
  final String? paymentGatewayResponse;

  UpdatePaymentEvent({required this.orderId, this.paymentGatewayResponse});
}
