class DeleteAccountRequestModel {
  final int userId;
  final String apiToken;

  DeleteAccountRequestModel({required this.userId, required this.apiToken});

  Map<String, dynamic> toJson() => {"user_id": userId};
}
