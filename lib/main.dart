import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:yoga_app/Services/firebase_services.dart';
import 'package:yoga_app/features/Auth/bloc/login_bloc.dart';
import 'package:yoga_app/features/Auth/bloc/verification_bloc.dart';
import 'package:yoga_app/features/HelpAndSupport/bloc/help_and_support_bloc.dart';
import 'package:yoga_app/features/Notifications/cubit/notification_cubit.dart';
import 'package:yoga_app/features/SwitchCourse/bloc/switch_course_bloc.dart';
import 'package:yoga_app/features/Testimonials/bloc/testimonial_bloc.dart';
import 'package:yoga_app/features/booking/bloc/my_booking_bloc.dart';
import 'package:yoga_app/features/booking/bloc/view_detail_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/Notifications/views/notification_screen.dart';
import 'package:yoga_app/features/profile/bloc/delete_account_bloc.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/features/profile/bloc/update_profile_bloc.dart';
import 'package:yoga_app/features/purchase/bloc/booking_bloc.dart';
import 'package:yoga_app/features/purchase/bloc/yoga_detail_bloc.dart';
import 'package:yoga_app/features/search/bloc/search_bloc.dart';
import 'package:yoga_app/features/splash/bloc/splash_bloc.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:yoga_app/features/splash/views/splash_screen.dart';
import 'package:yoga_app/features/walkthrough/bloc/walk_through_bloc.dart';
import 'package:yoga_app/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final dir = await syspath.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // NotificationServices().initNotification();
  await Hive.openBox('LOCAL_STORAGE');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseServices().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc(),
        ),
        BlocProvider(
          create: (context) => WalkThroughBloc(),
        ),
        BlocProvider(
          create: (context) => VerificationBloc(),
        ),
        BlocProvider(
          create: (context) => UpdateProfileBloc(),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider(
          create: (context) => DashboardCubit(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => MyProfileBloc(),
        ),
        BlocProvider(
          create: (context) => YogaDetailBloc(),
        ),
        BlocProvider(
          create: (context) => BookingBloc(),
        ),
        BlocProvider(
          create: (context) => MyBookingBloc(),
        ),
        BlocProvider(
          create: (context) => ViewDetailBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => SwitchCourseBloc(),
        ),
        BlocProvider(
          create: (context) => TestimonialBloc(),
        ),
        BlocProvider(
          create: (context) => HelpAndSupportBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => DeleteAccountBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Sera Yoga',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: LightMode.theme(),
        darkTheme: DarkMode.theme(),
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
        routes: {
          NotificationScreen.route: (context) => const NotificationScreen()
        },
      ),
    );
  }
}
