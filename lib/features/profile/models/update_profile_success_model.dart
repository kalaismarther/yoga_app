import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

class UpdateProfileSuccessModel {
  final String message;
  final ProfileDetailModel userDetails;

  UpdateProfileSuccessModel({required this.message, required this.userDetails});

  factory UpdateProfileSuccessModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileSuccessModel(
          message: json['message']?.toString() ?? '',
          userDetails: ProfileDetailModel.fromJson(json['data'] ?? {}));
}
