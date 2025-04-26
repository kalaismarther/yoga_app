part of 'help_and_support_bloc.dart';

@immutable
sealed class HelpAndSupportState {}

final class HelpAndSupportInitial extends HelpAndSupportState {}

final class HelpRequestLoadingState extends HelpAndSupportState {}

final class HelpRequestSuccessState extends HelpAndSupportState {
  final String message;

  HelpRequestSuccessState({required this.message});
}

final class HelpRequestFailureState extends HelpAndSupportState {
  final String error;

  HelpRequestFailureState({required this.error});
}

final class HelpRequestExpiredState extends HelpRequestFailureState {
  HelpRequestExpiredState({required super.error});
}
