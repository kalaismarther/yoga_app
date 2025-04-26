import 'package:yoga_app/features/profile/models/profile_detail_model.dart';

class EditProfileSuccessModel extends ProfileDetailModel {
  EditProfileSuccessModel(
      {required super.userId,
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
      required super.deviceId});
}
