class MyBookingRequestModel {
  final int userId;
  final int type;
  final String apiToken;

  MyBookingRequestModel(
      {required this.userId, required this.type, required this.apiToken});

  Map<String, dynamic> toJson() => {'user_id': userId, 'type': type};
}
