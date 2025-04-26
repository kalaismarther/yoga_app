class LoginFailureModel {
  final String error;

  LoginFailureModel({required this.error});

  String errorMessage() => error;
}
