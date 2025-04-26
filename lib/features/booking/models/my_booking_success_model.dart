import 'package:yoga_app/Helper/date_helper.dart';
import 'package:yoga_app/features/booking/models/my_booking_model.dart';

class MyBookingSuccessModel {
  final List<MyBookingModel> mybookingsList;

  MyBookingSuccessModel({required this.mybookingsList});

  factory MyBookingSuccessModel.fromJson(List<dynamic> list) =>
      MyBookingSuccessModel(
        mybookingsList: [
          for (final json in list)
            MyBookingModel(
              id: int.parse(json['id']?.toString() ?? '0'),
              bookingRefNo: json['booking_unique_id']?.toString() ?? '',
              yogaName: json['is_yoga_class']?.toString() ?? '',
              bookedDate: json['formatted_created_at']?.toString() ?? '',
              startDate: DateHelper.ddmmmyyyyStringFormat(
                  json['start_date']?.toString() ?? ''),
              endDate: DateHelper.ddmmmyyyyStringFormat(
                  json['end_date']?.toString() ?? ''),
              timeSlot: json['is_time_slot']?.toString() ?? '',
              remainingClasses:
                  int.parse(json['is_remaining_classes']?.toString() ?? '0'),
              totalClasses: int.parse(json['no_of_class']?.toString() ?? '0'),
              amount: json['is_duration_amount']?.toString() ?? '',
              zoomLink: json['is_zoom_link']?.toString() ?? '',
              switchStatus:
                  int.parse(json['is_switched_course']?.toString() ?? '0'),
              dateExpired:
                  (json['is_course_flag']?.toString() == '0') ? true : false,
            )
        ],
      );
}
