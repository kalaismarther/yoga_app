import 'package:yoga_app/features/purchase/models/duration_model.dart';
import 'package:yoga_app/features/purchase/models/time_slot_model.dart';

class YogaDetailSuccessModel {
  final int id;
  final bool inAppPurchase;
  final String classProductId;
  final String name;
  final String headerImageLink;
  final String about;
  final List<dynamic> days;
  final List<TimeSlotModel> timings;
  final List<DurationModel> durationList;
  final bool isOngoingcourse;
  final bool isFreeClassAvailable;
  final bool isTrialClassAvailable;

  YogaDetailSuccessModel(
      {required this.id,
      required this.inAppPurchase,
      required this.classProductId,
      required this.name,
      required this.headerImageLink,
      required this.about,
      required this.days,
      required this.timings,
      required this.durationList,
      required this.isOngoingcourse,
      required this.isFreeClassAvailable,
      required this.isTrialClassAvailable});

  factory YogaDetailSuccessModel.fromJson(Map<String, dynamic> json) =>
      YogaDetailSuccessModel(
        id: int.parse(json['data']?['id']?.toString() ?? '0'),
        inAppPurchase: json['app_purchase']?.toString() == '1',
        classProductId: json['data']?['class_product_id']?.toString() ?? '',
        name: json['data']?['name']?.toString() ?? '',
        headerImageLink: json['data']?['is_yoga_image']?.toString() ?? '',
        about: json['data']?['about_us']?.toString() ?? '',
        days: json['data']?['is_days'] ?? [],
        timings: [
          for (final time in json['data']?['is_time_slot'] ?? [])
            TimeSlotModel.fromJson(time)
        ],
        durationList: [
          for (final duration in json['duration_list'] ?? [])
            DurationModel.fromJson(duration)
        ],
        isOngoingcourse:
            int.parse(json['data']?['is_course_flag']?.toString() ?? '0') == 1,
        isFreeClassAvailable:
            int.parse(json['data']?['free_class']?.toString() ?? '0') == 1,
        isTrialClassAvailable:
            int.parse(json['data']?['trial_class']?.toString() ?? '0') == 1,
      );
}
