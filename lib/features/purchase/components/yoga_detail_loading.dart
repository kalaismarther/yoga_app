import 'package:flutter/material.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class YogaDetailLoading extends StatelessWidget {
  const YogaDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: DeviceSize.screenHeight(context) * 0.4,
                width: DeviceSize.screenWidth(context),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: LoadingShimmer(
                  height: double.infinity,
                  width: double.infinity,
                  baseColor: Theme.of(context).colorScheme.tertiary,
                  highlightColor: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              Positioned(
                top: 46,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Nav.pop(context);
                  },
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? AppImages.goBack
                        : AppImages.backArrowWhite,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the Yoga',
                    style: TextStyle(fontSize: mobile ? null : 24),
                  ),
                  const VerticalSpace(height: 10),
                  LoadingShimmer(
                    height: 12,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  const VerticalSpace(height: 8),
                  LoadingShimmer(
                    height: 12,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  const VerticalSpace(height: 8),
                  LoadingShimmer(
                    height: 12,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  const VerticalSpace(height: 8),
                  LoadingShimmer(
                    height: 12,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  const VerticalSpace(height: 8),
                  LoadingShimmer(
                    height: 12,
                    width: double.infinity,
                    baseColor: Theme.of(context).colorScheme.tertiary,
                    highlightColor: Theme.of(context).colorScheme.onTertiary,
                  ),
                  const VerticalSpace(height: 30),
                  Text(
                    'Available Days',
                    style: TextStyle(fontSize: mobile ? null : 24),
                  ),
                  const VerticalSpace(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Container(
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.only(right: 10),
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
                          width: 100,
                          baseColor: Theme.of(context).colorScheme.tertiary,
                          highlightColor:
                              Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 30),
                  Text(
                    'Available Timings',
                    style: TextStyle(fontSize: mobile ? null : 24),
                  ),
                  const VerticalSpace(height: 10),
                  GridView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3.4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemBuilder: (context, index) => Container(
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
                        height: 12,
                        width: double.infinity,
                        baseColor: Theme.of(context).colorScheme.tertiary,
                        highlightColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20)
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        height: 52,
        width: double.infinity,
        margin: const EdgeInsets.all(14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LoadingShimmer(
          height: double.infinity,
          width: double.infinity,
          baseColor: Theme.of(context).colorScheme.primary,
          highlightColor: Colors.grey.shade300.withOpacity(0.3),
        ),
      ),
    );
  }
}
