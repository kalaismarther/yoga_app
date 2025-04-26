import 'package:yoga_app/features/purchase/models/duration_model.dart';
import 'package:yoga_app/features/purchase/models/time_slot_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_success_model.dart';

class SummaryViewModel {
  final YogaDetailSuccessModel selectedYoga;
  final DurationModel selectedDuration;
  final String preferredStartDate;
  final TimeSlotModel selectedTime;

  SummaryViewModel(
      {required this.selectedYoga,
      required this.selectedDuration,
      required this.preferredStartDate,
      required this.selectedTime});
}
