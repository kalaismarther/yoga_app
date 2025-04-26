import 'package:flutter/material.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyProfileLoading extends StatelessWidget {
  const MyProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          const VerticalSpace(height: 20),
          Container(
            height: 100,
            width: 100,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: LoadingShimmer(
              height: double.infinity,
              width: double.infinity,
              baseColor: Theme.of(context).colorScheme.tertiary,
              highlightColor: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          const VerticalSpace(height: 30),
          for (int i = 0; i < 5; i++)
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.outline),
              ),
              child: Container(
                height: 20,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: LoadingShimmer(
                  height: double.infinity,
                  width: double.infinity,
                  baseColor: Theme.of(context).colorScheme.tertiary,
                  highlightColor: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
          const VerticalSpace(height: 10),
          Container(
            clipBehavior: Clip.hardEdge,
            height: 52,
            width: double.infinity,
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
        ],
      ),
    );
  }
}
