class VerificationRequestModel {
  final int? userId;
  final String mobileNo;
  final String otp;
  final String deviceType;
  final String deviceId;
  final String fcmToken;

  VerificationRequestModel(
      {this.userId,
      required this.mobileNo,
      required this.otp,
      required this.deviceType,
      required this.deviceId,
      required this.fcmToken});

  Map<String, dynamic> toJson() => {
        if (userId == null) ...{
          "mobileandemail": mobileNo,
          "otp": otp,
          "device_type": deviceType,
          "device_id": deviceId,
          "fcm_token": fcmToken,
        } else ...{
          'mobileoremail': mobileNo,
          "user_id": userId!,
          "otp": otp,
        }
      };
}
