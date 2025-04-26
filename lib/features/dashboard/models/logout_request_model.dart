class LogoutRequestModel {
  final int userId;
  final String fcmToken;
  final String deviceId;
  final String deviceType;
  final String apiToken;

  LogoutRequestModel(
      {required this.userId,
      required this.fcmToken,
      required this.deviceId,
      required this.deviceType,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "fcm_token": fcmToken,
        "device_id": deviceId,
        "device_type": deviceType
      };
}
