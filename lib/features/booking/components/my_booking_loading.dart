import 'package:flutter/material.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyBookingLoading extends StatelessWidget {
  const MyBookingLoading({super.key, required this.currentType});

  final int currentType;

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.mybookingBg),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 16 : 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: currentType == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Ongoing',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: mobile ? null : 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const HorizontalSpace(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: currentType == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Completed',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: mobile ? null : 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            const VerticalSpace(height: 14),
            ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                height: 130,
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      )
                  ],
                ),
                child: LoadingShimmer(
                  height: double.infinity,
                  width: double.infinity,
                  baseColor: Theme.of(context).colorScheme.tertiary,
                  highlightColor: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
