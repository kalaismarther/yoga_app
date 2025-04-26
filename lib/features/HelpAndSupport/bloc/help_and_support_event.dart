part of 'help_and_support_bloc.dart';

@immutable
sealed class HelpAndSupportEvent {}

class SendHelpRequestEvent extends HelpAndSupportEvent {
  final String title;
  final String comment;

  SendHelpRequestEvent({required this.title, required this.comment});
}
