part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final LoginRequestModel input;

  LoginButtonPressedEvent({required this.input});
}
