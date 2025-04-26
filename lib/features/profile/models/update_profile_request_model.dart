class UpdateProfileRequestModel {
  final int userId;
  final String name;
  // final String email;
  final String dob;
  final String gender;
  final String occupation;
  final String city;
  final String weight;
  final String height;
  final String healthIssues;
  final String previousYogaKnowledge;
  final String surgery;

  final String apiToken;

  UpdateProfileRequestModel(
      {required this.userId,
      required this.name,
      // required this.email,
      required this.dob,
      required this.gender,
      required this.occupation,
      required this.city,
      required this.weight,
      required this.height,
      required this.healthIssues,
      required this.previousYogaKnowledge,
      required this.surgery,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        // "email": email,
        "dob": dob,
        "gender": gender,
        "occupation": occupation,
        "city": city,
        "weight": weight,
        "height": height,
        "health_issue": healthIssues,
        "previous_knowledge_of_yoga": previousYogaKnowledge,
        "surgery": surgery
      };
}
