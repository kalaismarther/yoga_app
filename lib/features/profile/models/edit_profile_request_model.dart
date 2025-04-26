import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

class EditProfileRequestModel extends ProfileDetailModel {
  EditProfileRequestModel({
    required super.userId,
    required super.name,
    required super.profileImage,
    required super.mobile,
    required super.email,
    required super.dob,
    required super.gender,
    required super.occupation,
    required super.city,
    required super.weight,
    required super.height,
    required super.healthIssues,
    required super.previousYogaKnowledge,
    required super.surgery,
    required super.fcmToken,
    required super.apiToken,
    required super.isProfileUpdated,
    required super.deviceType,
    required super.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'dob': dob,
        'gender': gender,
        'occupation': occupation,
        'city': city,
        'weight': weight,
        'height': height,
        'health_issue': healthIssues,
        'previous_knowledge_of_yoga': previousYogaKnowledge,
        'surgery': surgery,
        'fcm_token': fcmToken,
        'device_type': deviceType,
        'device_id': deviceId
      };
}
