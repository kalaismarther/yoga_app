part of 'yoga_detail_bloc.dart';

@immutable
sealed class YogaDetailState {}

final class YogaDetailInitialState extends YogaDetailState {}

final class YogaDetailSuccessState extends YogaDetailState {
  final YogaDetailSuccessModel data;

  YogaDetailSuccessState({required this.data});
}

final class YogaDetailFailureState extends YogaDetailState {
  final String error;

  YogaDetailFailureState({required this.error});
}

final class YogaDetailSessionExpiredState extends YogaDetailState {
  final String error;

  YogaDetailSessionExpiredState({required this.error});
}
