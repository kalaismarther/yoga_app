class SearchRequestModel {
  final int userId;
  final String keyword;
  final String apiToken;

  SearchRequestModel(
      {required this.userId, required this.keyword, required this.apiToken});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'search': keyword,
      };
}
