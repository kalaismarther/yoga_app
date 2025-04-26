import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/profile/models/delete_account_request_model.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/profile/repo/profile_api.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc() : super(DeleteAccountInitial()) {
    on<DeleteMyAccountEvent>((event, emit) async {
      emit(DeleteAccountLoading());

      final detail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(detail);

      var input = DeleteAccountRequestModel(
          userId: user.userId, apiToken: user.apiToken);

      final apiResult = await ProfileApi.deleteUserAccount(input);

      if (apiResult.success) {
        if (apiResult.data['status'].toString() == '1') {
          emit(DeleteAccountSuccess());
        } else if (apiResult.data['status'].toString() == '2') {
          emit(DeleteAccountExpired(
              error: apiResult.data['message']?.toString() ?? ''));
        } else {
          emit(DeleteAccountFailed(error: apiResult.data['message'] ?? ''));
        }
      } else {
        emit(DeleteAccountFailed(error: apiResult.data['message'] ?? ''));
      }
    });
  }
}
