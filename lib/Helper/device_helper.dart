import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceHelper {
  static Future<Device> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;

      return Device(id: iosInfo.identifierForVendor ?? '', type: 'IOS');
    } else {
      var androidInfo = await deviceInfoPlugin.androidInfo;

      return Device(id: androidInfo.id, type: 'ANDROID');
    }
  }

  static Future<String> getFCM() async {
    final fcm = FirebaseMessaging.instance;
    String? token = await fcm.getToken();
    return token ?? '';
  }
}

class Device {
  final String id;
  final String type;

  Device({required this.id, required this.type});
}
