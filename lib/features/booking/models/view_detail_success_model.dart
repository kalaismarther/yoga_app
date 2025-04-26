import 'package:yoga_app/Helper/date_helper.dart';
import 'package:yoga_app/features/booking/models/my_booking_model.dart';
import 'package:yoga_app/features/booking/models/previous_booking_model.dart';

class ViewDetailSuccessModel {
  final MyBookingModel bookingDetail;
  final List<PreviousBookingModel> previousBookings;

  ViewDetailSuccessModel(
      {required this.bookingDetail, required this.previousBookings});

  factory ViewDetailSuccessModel.fromJson(Map<String, dynamic> json) =>
      ViewDetailSuccessModel(
        bookingDetail: MyBookingModel(
          id: int.parse(json['data']?['id']?.toString() ?? '0'),
          bookingRefNo: json['data']?['booking_unique_id']?.toString() ?? '',
          yogaName: json['data']?['is_yoga_class']?.toString() ?? '',
          bookedDate: json['data']?['formatted_created_at']?.toString() ?? '',
          startDate: json['data']?['start_date']?.toString() ?? '',
          endDate: DateHelper.ddmmmyyyyStringFormat(
              json['data']?['end_date']?.toString() ?? ''),
          timeSlot: json['data']?['is_time_slot']?.toString() ?? '',
          remainingClasses: int.parse(
              json['data']?['is_remaining_classes']?.toString() ?? '0'),
          totalClasses:
              int.parse(json['data']?['no_of_class']?.toString() ?? '0'),
          amount: json['data']?['is_duration_amount']?.toString() ?? '',
          zoomLink: json['data']?['is_zoom_link']?.toString() ?? '',
          switchStatus:
              int.parse(json['data']?['is_switched_course']?.toString() ?? '0'),
          dateExpired: json['data']?['is_course_flag']?.toString() == '0',
        ),
        previousBookings: [
          for (var booking in json['bookinghistory'] ?? [])
            PreviousBookingModel.fromJson(booking)
        ],
      );
}
