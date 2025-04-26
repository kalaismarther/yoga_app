class ProfileImageRequestModel {
  final int userId;
  final String imagePath;
  final String apiToken;

  ProfileImageRequestModel(
      {required this.userId, required this.imagePath, required this.apiToken});
}
