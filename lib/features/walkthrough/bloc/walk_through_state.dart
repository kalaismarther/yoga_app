part of 'walk_through_bloc.dart';

@immutable
sealed class WalkThroughState {}

final class WalkThroughInitial extends WalkThroughState {}

final class WalkThroughLoadingState extends WalkThroughState {}

final class WalkThroughSuccessState extends WalkThroughState {
  final WalkthroughSuccessModel data;

  WalkThroughSuccessState({required this.data});
}

final class WalkThroughFailureState extends WalkThroughState {
  final WalkthroughFailureModel error;

  WalkThroughFailureState({required this.error});
}
