import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

class VerificationSuccessModel {
  final int status;
  final String message;
  final ProfileDetailModel userData;

  VerificationSuccessModel(
      {required this.status, required this.message, required this.userData});

  factory VerificationSuccessModel.fromJson(Map<String, dynamic> json) =>
      VerificationSuccessModel(
        status: int.parse(json['status']?.toString() ?? '0'),
        message: json['message'] ?? '',
        userData: ProfileDetailModel.fromJson(json['data'] ?? {}),
      );
}
