import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga_app/Services/pref_service.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>((event, emit) {});
    on<SplashInitialEvent>((event, emit) async {
      PrefService.pref = await SharedPreferences.getInstance();
      bool? existingUser = await PrefService.readBool('logged');

      if (existingUser == true) {
        emit(MoveToDashboardScreenState());
      } else {
        emit(MoveToGetStartedScreenState());
      }
    });
  }
}
