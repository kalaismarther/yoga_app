class HelpRequestModel {
  final int userId;
  final String messageType;
  final String description;
  final String apiToken;

  HelpRequestModel(
      {required this.userId,
      required this.messageType,
      required this.description,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "title": messageType,
        "comment": description,
      };
}
