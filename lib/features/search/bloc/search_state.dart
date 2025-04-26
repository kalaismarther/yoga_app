part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoadingState extends SearchState {}

class SearchNavigationState extends SearchState {}

final class SearchSuccessState extends SearchState {
  final SearchSuccessModel data;

  SearchSuccessState({required this.data});
}

final class SearchYogaItemClickedState extends SearchNavigationState {}

final class SearchFailureState extends SearchState {
  final SearchFailureModel error;

  SearchFailureState({required this.error});
}

final class SearchNetworkErrorState extends SearchState {}

final class SearchExpiredState extends SearchState {
  final String error;

  SearchExpiredState({required this.error});
}
