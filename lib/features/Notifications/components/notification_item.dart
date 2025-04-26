import 'package:flutter/material.dart';
import 'package:yoga_app/features/Notifications/models/notification_model.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppImages.notification,
              height: mobile ? 36 : 40,
            ),
            const HorizontalSpace(width: 14),
            SizedBox(
              width: DeviceSize.screenWidth(context) * 0.62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: mobile ? 16 : 20),
                  ),
                  const VerticalSpace(height: 6),
                  Text(notification.body,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: mobile ? 14 : 18)),
                  const VerticalSpace(height: 8),
                  Text(
                    notification.time,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: mobile ? 11 : 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
