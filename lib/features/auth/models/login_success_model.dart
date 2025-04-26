class LoginSuccessModel {
  final String message;
  final String data;

  LoginSuccessModel({required this.message, required this.data});

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      LoginSuccessModel(
        message: json['message'] ?? '',
        data: json['data']?.toString() ?? '',
      );
}
