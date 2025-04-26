part of 'verification_bloc.dart';

@immutable
sealed class VerificationState {}

final class VerificationInitial extends VerificationState {}

final class VerificationLoadingState extends VerificationState {}

final class TimerRunningState extends VerificationState {
  final int seconds;

  TimerRunningState({required this.seconds});
}

final class TimerFinishedState extends VerificationState {}

final class VerificationSuccessState extends VerificationState {
  final VerificationSuccessModel data;

  VerificationSuccessState({required this.data});
}

final class VerificationFailureState extends VerificationState {
  final VerificationFailureModel reason;

  VerificationFailureState({required this.reason});
}

final class NewUserState extends VerificationSuccessState {
  NewUserState({required super.data});
}

final class ExistingUserState extends VerificationSuccessState {
  ExistingUserState({required super.data});
}

final class ResendOtpSuccessState extends VerificationState {
  final ResendSuccessModel data;

  ResendOtpSuccessState({required this.data});
}

final class ResendOtpFailureState extends VerificationState {
  final ResendFailureModel error;

  ResendOtpFailureState({required this.error});
}
