import 'package:hive/hive.dart';

class HiveServices {
  static final storage = Hive.box('LOCAL_STORAGE');

  static Future write(String keyName, dynamic values) async {
    return await storage.put(keyName, values);
  }

  static Future read(String keyName) async {
    return await storage.get(keyName);
  }

  static Future deleteAll() async {
    return await storage.clear();
  }
}
