part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchYogaEvent extends SearchEvent {
  final String keyword;

  SearchYogaEvent({required this.keyword});
}

class SearchYogaItemClickedEvent extends SearchEvent {}
