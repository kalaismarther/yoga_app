import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    bool tab = DeviceSize.screenWidth(context) > 576;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: tab ? 82 : 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: Platform.isIOS ? const EdgeInsets.only(bottom: 16) : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white, fontSize: tab ? 26 : null),
            ),
            Image.asset(
              AppImages.nextArrow,
              height: tab ? 38 : 16,
              width: tab ? 38 : 16,
            )
          ],
        ),
      ),
    );
  }
}
