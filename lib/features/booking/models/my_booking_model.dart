class MyBookingModel {
  final int id;
  final String bookingRefNo;
  final String yogaName;
  final String bookedDate;
  final String startDate;
  final String endDate;
  final String timeSlot;
  final int remainingClasses;
  final int totalClasses;
  final String amount;
  final String zoomLink;
  final int switchStatus;
  final bool dateExpired;

  MyBookingModel(
      {required this.id,
      required this.bookingRefNo,
      required this.yogaName,
      required this.bookedDate,
      required this.startDate,
      required this.endDate,
      required this.timeSlot,
      required this.remainingClasses,
      required this.totalClasses,
      required this.amount,
      required this.zoomLink,
      required this.switchStatus,
      required this.dateExpired});
}
