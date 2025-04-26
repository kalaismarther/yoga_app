part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final LoginSuccessModel data;

  LoginSuccessState({required this.data});
}

final class LoginFailureState extends LoginState {
  final LoginFailureModel reason;

  LoginFailureState({required this.reason});
}
