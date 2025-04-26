import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static late SharedPreferences pref;

  static Future<void> writeBool(String key, bool value) async {
    await pref.setBool(key, value);
  }

  static Future<bool?> readBool(String key) async {
    return pref.getBool(key);
  }

  static Future<bool?> clear() async {
    return pref.clear();
  }
}
