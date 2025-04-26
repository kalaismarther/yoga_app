import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yoga_app/Services/network_services.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/Notifications/views/notification_screen.dart';
import 'package:yoga_app/features/splash/bloc/splash_bloc.dart';
import 'package:yoga_app/features/walkthrough/views/getstarted_screen.dart';
import 'package:yoga_app/main.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:new_version_plus/new_version_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<ConnectivityResult> connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool hasInternet = true;
  bool isAlertSet = false;
  bool isNotificationTapped = false;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 800), () {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          isNotificationTapped = true;
          navigatorKey.currentState?.pushNamed(NotificationScreen.route);
        } else {
          if (!isNotificationTapped) {
            if (mounted) {
              initialize();
            }
          }
        }
      });
    });
    checkConnection();
    super.initState();
  }

  void checkConnection() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) async {
      bool networkEnabled = await InternetConnectionChecker().hasConnection;
      hasInternet = networkEnabled;

      if (!hasInternet && !isAlertSet) {
        showNoInternetAlert();
        isAlertSet = true;
      }
    });
  }

  void showNoInternetAlert() => showCupertinoDialog(
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: const Text('No internet connection'),
            content: const Text(
                'Please check your internet connection and Click \'Ok\' to try again'),
            actions: [
              TextButton(
                onPressed: () async {
                  Nav.pop(context);
                  isAlertSet = false;
                  bool networkEnabled =
                      await InternetConnectionChecker().hasConnection;
                  if (!networkEnabled) {
                    showNoInternetAlert();
                    isAlertSet = true;
                  }
                },
                child: const Text('Ok'),
              )
            ],
          ),
        ),
      );

  void initialize() async {
    bool hasInternet = await NetworkServices.hasInternetConnection();

    if (!hasInternet) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Network Error"),
            content: const Text(
                "Network connection not available. Please check your internet connection."),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  initialize();
                },
              ),
            ],
          );
        },
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), checkUpdateAndStartApp);
    }
  }

  Future<void> checkUpdateAndStartApp() async {
    final newVersion = NewVersionPlus(
        androidId: 'com.smart.yogaapp', iOSId: 'com.smart.yogaapp');

    final status = await newVersion.getVersionStatus();

    if (status != null && status.canUpdate) {
      showDialog(
        barrierColor: Colors.black26,
        barrierDismissible: false,
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: Row(
              children: [
                Platform.isIOS
                    ? Image.asset(
                        AppImages.appStore,
                        height: 24,
                      )
                    : Image.asset(
                        AppImages.playStore,
                        height: 24,
                      ),
                const HorizontalSpace(width: 10),
                const Text(
                  'Update Available',
                  style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ],
            ),
            content: Text(
                'New version of this app is now available on ${Platform.isIOS ? 'App Store' : 'Play Store'}. Please update it'),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        launchUrlString(status.appStoreLink);
                      },
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      context.read<SplashBloc>().add(SplashInitialEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      builder: (context, state) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          child: Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.logo,
                height: 250,
                width: 250,
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is MoveToGetStartedScreenState) {
          Nav.push(context, const GetstartedScreen());
        } else if (state is MoveToDashboardScreenState) {
          Nav.push(context, const DashboardScreen());
        }
      },
    );
  }
}
