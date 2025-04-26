part of 'my_profile_bloc.dart';

@immutable
sealed class MyProfileEvent {}

class GetProfileEvent extends MyProfileEvent {}

class SaveChagesButtonClickedEvent extends MyProfileEvent {
  final EditProfileRequestModel input;

  SaveChagesButtonClickedEvent({required this.input});
}

class CameraIconClickedEvent extends MyProfileEvent {}

class UpdateProfileImageEvent extends MyProfileEvent {
  final String imagePath;

  UpdateProfileImageEvent({required this.imagePath});
}
