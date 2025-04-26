part of 'delete_account_bloc.dart';

@immutable
sealed class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountFailed extends DeleteAccountState {
  final String error;

  DeleteAccountFailed({required this.error});
}

class DeleteAccountExpired extends DeleteAccountFailed {
  DeleteAccountExpired({required super.error});
}
