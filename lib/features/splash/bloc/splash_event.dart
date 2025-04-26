part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {}

class SplashInitialEvent extends SplashEvent {}

class SplashCheckInternetEvent extends SplashEvent {}
