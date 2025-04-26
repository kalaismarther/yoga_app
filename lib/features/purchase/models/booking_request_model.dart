class BookingRequestModel {
  final int userId;
  final int classId;
  final int durationId;
  final int timeslotId;
  final String startDate;
  final String apiToken;
  final int isIos;

  BookingRequestModel(
      {required this.userId,
      required this.classId,
      required this.durationId,
      required this.timeslotId,
      required this.startDate,
      required this.isIos,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "class_id": classId,
        "duration_id": durationId,
        "timeslot_id": timeslotId,
        "start_date": startDate,
        "is_ios": isIos,
      };
}
