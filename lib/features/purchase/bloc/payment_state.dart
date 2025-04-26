part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class UpdatePaymentLoading extends PaymentState {}

class UpdatePaymentSuccess extends PaymentState {}

class UpdatePaymentFailed extends PaymentState {
  final String error;

  UpdatePaymentFailed({required this.error});
}

class UpdatePaymentExpired extends UpdatePaymentFailed {
  UpdatePaymentExpired({required super.error});
}
