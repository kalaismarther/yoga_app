import 'package:flutter/material.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Icon(
              Icons.wifi_off,
              color: Theme.of(context).colorScheme.primary,
              size: 80,
            ),
            const VerticalSpace(height: 20),
            const Text('No internet connection')
          ],
        ),
      ),
    );
  }
}
