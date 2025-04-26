class SwitchCourseRequestModel {
  final int userId;
  final int bookingId;
  final int newClassId;
  final int timeSlotId;
  final String apiToken;

  SwitchCourseRequestModel(
      {required this.userId,
      required this.bookingId,
      required this.newClassId,
      required this.timeSlotId,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "booking_id": bookingId,
        "new_class_id": newClassId,
        "time_slot_id": timeSlotId,
      };
}
