part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class MoveToGetStartedScreenState extends SplashState {}

final class MoveToDashboardScreenState extends SplashState {}

final class NetworkEnabledState extends SplashState {}

final class NetworkDisabledState extends SplashState {}
