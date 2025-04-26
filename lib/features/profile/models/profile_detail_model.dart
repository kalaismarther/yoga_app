class ProfileDetailModel {
  final int userId;
  final String name;
  final String profileImage;
  final String mobile;
  final String email;
  final String dob;
  final String gender;
  final String occupation;
  final String city;
  final String weight;
  final String height;
  final String healthIssues;
  final String previousYogaKnowledge;
  final String surgery;

  final String fcmToken;
  final String apiToken;
  final int isProfileUpdated;
  final String deviceType;
  final String deviceId;

  ProfileDetailModel({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.gender,
    required this.occupation,
    required this.city,
    required this.weight,
    required this.height,
    required this.healthIssues,
    required this.previousYogaKnowledge,
    required this.surgery,
    required this.fcmToken,
    required this.apiToken,
    required this.isProfileUpdated,
    required this.deviceType,
    required this.deviceId,
  });

  factory ProfileDetailModel.fromJson(Map<dynamic, dynamic> json) =>
      ProfileDetailModel(
        userId: int.parse(json['id']?.toString() ?? '0'),
        name: json['name'] ?? '',
        profileImage: json['is_user_profile_image'] ?? '',
        mobile: json['mobile']?.toString() ?? '',
        email: json['email'] ?? '',
        dob: json['dob'] ?? '',
        gender: json['gender'] ?? '',
        occupation: json['occupation'] ?? '',
        city: json['city'] ?? '',
        weight: json['weight']?.toString() ?? '',
        height: json['height']?.toString() ?? '',
        healthIssues: json['health_issue'] ?? '',
        previousYogaKnowledge: json['previous_knowledge_of_yoga'] ?? '',
        surgery: json['surgery'] ?? '',
        apiToken: json['api_token'] ?? '',
        fcmToken: json['fcm_id'] ?? '',
        isProfileUpdated:
            int.parse(json['is_profile_updated']?.toString() ?? '0'),
        deviceType: json['device_type'] ?? '',
        deviceId: json['device_id'] ?? '',
      );
}
