part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeSuccessState extends HomeState {
  final HomeSuccessModel data;

  HomeSuccessState({required this.data});
}

class HomeFailureState extends HomeState {
  final HomeFailureModel error;

  HomeFailureState({required this.error});
}

final class HomeNetworkErrorState extends HomeState {}

final class HomeNavigationState extends HomeState {}

final class YogaItemClickedState extends HomeNavigationState {}

final class HomeExpiredState extends HomeNavigationState {
  final String error;

  HomeExpiredState({required this.error});
}
