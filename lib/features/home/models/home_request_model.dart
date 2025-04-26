class HomeRequestModel {
  final int userId;
  final String apiToken;

  HomeRequestModel({required this.userId, required this.apiToken});

  Map<String, dynamic> toJson() => {'user_id': userId};
}
