class PreviousBookingModel {
  final int id;
  final String className;
  final String timeSlot;
  final int totalClasses;
  final int remainingClasses;
  final String bookedDate;

  PreviousBookingModel(
      {required this.id,
      required this.className,
      required this.timeSlot,
      required this.totalClasses,
      required this.remainingClasses,
      required this.bookedDate});

  factory PreviousBookingModel.fromJson(Map<String, dynamic> json) =>
      PreviousBookingModel(
          id: int.parse(json['id']?.toString() ?? '0'),
          className: json['is_yoga_class']?.toString() ?? '',
          timeSlot: json['is_time_slot']?.toString() ?? '',
          totalClasses: int.parse(json['no_of_class']?.toString() ?? '0'),
          remainingClasses:
              int.parse(json['is_remaining_classes']?.toString() ?? '0'),
          bookedDate: json['formatted_created_at']?.toString() ?? '');
}
