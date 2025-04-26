class ViewDetailRequestModel {
  final int userId;
  final int bookingId;
  final String apiToken;

  ViewDetailRequestModel(
      {required this.userId, required this.bookingId, required this.apiToken});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'booking_id': bookingId,
      };
}
