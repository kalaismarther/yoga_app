class NotificationRequestModel {
  final int userId;
  final int pageNo;
  final String apiToken;

  NotificationRequestModel(
      {required this.userId, required this.pageNo, required this.apiToken});

  Map<String, dynamic> toJson() => {'user_id': userId, 'page_no': pageNo};
}
