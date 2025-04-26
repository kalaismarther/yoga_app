import 'package:flutter/material.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/Services/pref_service.dart';
import 'package:yoga_app/features/splash/views/splash_screen.dart';

class UserHelper {
  static Future<void> logoutApp(BuildContext context) async {
    await HiveServices.deleteAll();
    await PrefService.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        ModalRoute.withName('/splash_screen'),
      );
    }
  }
}
