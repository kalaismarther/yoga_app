class PaymentRequestModel {
  final int userId;
  final int bookingSummaryId;
  final String paymentId;
  final String paymentStatus;
  final String apiToken;

  PaymentRequestModel(
      {required this.userId,
      required this.bookingSummaryId,
      required this.paymentId,
      required this.paymentStatus,
      required this.apiToken});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "bookingsummary_id": bookingSummaryId,
        "payment_id": paymentId,
        "payment_status": paymentStatus,
      };
}
