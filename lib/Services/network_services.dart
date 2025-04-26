import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkServices {
  static Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
