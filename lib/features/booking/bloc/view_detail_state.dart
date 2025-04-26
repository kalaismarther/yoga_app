part of 'view_detail_bloc.dart';

@immutable
sealed class ViewDetailState {}

final class ViewDetailInitial extends ViewDetailState {}

class ViewDetailLoadingState extends ViewDetailState {}

class ViewDetailSuccessState extends ViewDetailState {
  final ViewDetailSuccessModel data;

  ViewDetailSuccessState({required this.data});
}

class ViewDetailFailureState extends ViewDetailState {
  final ViewDetailFailureModel error;

  ViewDetailFailureState({required this.error});
}

class ViewDetailExpiredState extends ViewDetailState {
  final String error;

  ViewDetailExpiredState({required this.error});
}
