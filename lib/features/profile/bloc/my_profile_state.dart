part of 'my_profile_bloc.dart';

@immutable
sealed class MyProfileState {}

final class MyProfileInitial extends MyProfileState {}

class ActionState extends MyProfileState {}

//My Profile
class ProfileDetailLoadingState extends ActionState {}

class ProfileDetailState extends MyProfileState {
  final bool? showDeleteIcon;
  final ProfileDetailModel profileData;

  ProfileDetailState({required this.profileData, this.showDeleteIcon});
}

//Edit Profile
class EditProfileLoadingState extends ActionState {}

class EditProfileSuccessState extends ActionState {
  final String message;
  EditProfileSuccessState({required this.message});
}

class EditProfileFailureState extends ActionState {
  final EditProfileFailureModel reason;

  EditProfileFailureState({required this.reason});
}

final class SessionExpiredState extends EditProfileFailureState {
  SessionExpiredState({required super.reason});
}

final class CameraIconClickedState extends ActionState {}

final class UpdateProfileImageSuccessState extends ActionState {
  final String successMessage;

  UpdateProfileImageSuccessState({required this.successMessage});
}

final class UpdateProfileImageFailureState extends ActionState {
  final String failureMessage;

  UpdateProfileImageFailureState({required this.failureMessage});
}

final class MobileNumberChangedState extends MyProfileState {}
