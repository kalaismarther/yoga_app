part of 'delete_account_bloc.dart';

@immutable
sealed class DeleteAccountEvent {}

class DeleteMyAccountEvent extends DeleteAccountEvent {}
