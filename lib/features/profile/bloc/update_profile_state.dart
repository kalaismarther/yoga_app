part of 'update_profile_bloc.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoadingState extends UpdateProfileState {}

final class UpdateProfileSuccessState extends UpdateProfileState {
  final bool? redirectToHomePage;
  final UpdateProfileSuccessModel data;

  UpdateProfileSuccessState({required this.data, this.redirectToHomePage});
}

final class UpdateProfileFailureState extends UpdateProfileState {
  final UpdateProfileFailureModel reason;

  UpdateProfileFailureState({required this.reason});
}

final class UpdateProfileExpiredState extends UpdateProfileFailureState {
  UpdateProfileExpiredState({required super.reason});
}
