import 'package:flutter/material.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class ViewDetailLoading extends StatelessWidget {
  const ViewDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Booking Summary'),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: LoadingShimmer(
                        height: 16,
                        width: DeviceSize.screenWidth(context) * 0.24,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(height: 10),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: LoadingShimmer(
                            height: double.infinity,
                            width: double.infinity,
                            baseColor: Theme.of(context).colorScheme.tertiary,
                            highlightColor:
                                Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      const HorizontalSpace(width: 10),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        width: DeviceSize.screenWidth(context) * 0.32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: LoadingShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          baseColor: Theme.of(context).colorScheme.tertiary,
                          highlightColor:
                              Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 10),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: LoadingShimmer(
                            height: double.infinity,
                            width: double.infinity,
                            baseColor: Theme.of(context).colorScheme.tertiary,
                            highlightColor:
                                Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 12),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 1.6,
                ),
                const VerticalSpace(height: 8),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            AppImages.calendars,
                            height: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const VerticalSpace(height: 14),
                          Image.asset(
                            AppImages.clock,
                            height: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const HorizontalSpace(width: 24),
                      VerticalDivider(
                        color: Theme.of(context).colorScheme.outline,
                        thickness: 1.6,
                      ),
                      const HorizontalSpace(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: LoadingShimmer(
                                height: 16,
                                width: DeviceSize.screenWidth(context) * 0.32,
                                baseColor:
                                    Theme.of(context).colorScheme.tertiary,
                                highlightColor:
                                    Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                            const VerticalSpace(height: 16),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: LoadingShimmer(
                                height: 16,
                                width: DeviceSize.screenWidth(context) * 0.32,
                                baseColor:
                                    Theme.of(context).colorScheme.tertiary,
                                highlightColor:
                                    Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpace(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pricing Summary'),
                const VerticalSpace(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: LoadingShimmer(
                        height: 16,
                        width: DeviceSize.screenWidth(context) * 0.22,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(height: 8),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 1.6,
                ),
                const VerticalSpace(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount Paid',
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: LoadingShimmer(
                        height: 16,
                        width: DeviceSize.screenWidth(context) * 0.22,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const VerticalSpace(height: 32),
          // Container(
          //   clipBehavior: Clip.hardEdge,
          //   height: 52,
          //   width: double.infinity,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: LoadingShimmer(
          //     height: double.infinity,
          //     width: double.infinity,
          //     baseColor: Theme.of(context).colorScheme.primary,
          //     highlightColor: Colors.grey.shade300.withOpacity(0.3),
          //   ),

          // ),
        ],
      ),
    );
  }
}
