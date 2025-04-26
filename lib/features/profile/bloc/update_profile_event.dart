part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileEvent {}

class UpdateProfileButtonPressedEvent extends UpdateProfileEvent {
  final UpdateProfileRequestModel input;

  UpdateProfileButtonPressedEvent({required this.input});
}
