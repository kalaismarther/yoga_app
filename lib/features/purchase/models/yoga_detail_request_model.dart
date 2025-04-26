class YogaDetailRequestModel {
  final int userId;
  final int courseId;

  YogaDetailRequestModel({required this.userId, required this.courseId});

  Map<String, dynamic> toJson() => {"user_id": userId, "course_id": courseId};
}
