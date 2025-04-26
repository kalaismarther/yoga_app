class ResendRequestModel {
  final int userId;
  final String mobileNo;

  ResendRequestModel({required this.userId, required this.mobileNo});

  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'mobileoremail': mobileNo};
}
