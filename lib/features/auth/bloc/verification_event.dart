part of 'verification_bloc.dart';

@immutable
sealed class VerificationEvent {}

class VerificationButtonPressedEvent extends VerificationEvent {
  final bool forLogin;
  final int? userId;
  final String mobNo;
  final String otp;

  VerificationButtonPressedEvent(
      {this.forLogin = true,
      this.userId,
      required this.mobNo,
      required this.otp});
}

class ResendButtonPressedEvent extends VerificationEvent {
  final String mobileNo;

  ResendButtonPressedEvent({required this.mobileNo});
}

class VerificationProfileEditEvent extends VerificationEvent {}
