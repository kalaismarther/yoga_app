import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/Auth/models/login_failure_model.dart';
import 'package:yoga_app/features/Auth/models/login_request_model.dart';
import 'package:yoga_app/features/Auth/models/login_success_model.dart';
import 'package:yoga_app/features/Auth/repo/auth_api.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressedEvent>((event, emit) async {
      emit(LoginLoadingState());

      final apiResult = await AuthApi.userLogin(event.input.toJson());

      if (apiResult.success) {
        emit(LoginSuccessState(
            data: LoginSuccessModel.fromJson(apiResult.data)));
      } else {
        emit(LoginFailureState(
            reason: LoginFailureModel(error: apiResult.errorMessage!)));
      }
    });
  }
}
