// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yoga_app/utils/device_size.dart';

class AppIndicators {
  static void dialogLoader(context) => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => const PopScope(
          canPop: false,
          child: Center(
            child: SpinKitPouringHourGlass(color: Colors.white),
          ),
        ),
      );

  static void paymentLoadingDialog(context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Processing payment"),
                ],
              ),
            ),
          ),
        ),
      );

  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        margin: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
      ),
      snackBarAnimationStyle: AnimationStyle(
        curve: Curves.easeInCubic,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  static void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      textColor: Theme.of(context).scaffoldBackgroundColor,
      fontSize: DeviceSize.screenWidth(context) < 576 ? 14 : 24,
    );
  }
}
