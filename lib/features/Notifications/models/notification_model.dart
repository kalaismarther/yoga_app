import 'package:yoga_app/Helper/date_helper.dart';

class NotificationModel {
  final String title;
  final String body;
  final String time;

  NotificationModel(
      {required this.title, required this.body, required this.time});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        title: json['title'] ?? '',
        body: json['content'] ?? '',
        time: DateHelper.formatDateTime(json['created_at']?.toString() ?? ''),
      );
}
