import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/booking/views/my_booking_screen.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/dashboard/components/bottom_navbar.dart';
import 'package:yoga_app/features/dashboard/components/side_menu.dart';
// import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/home/views/home_screen.dart';
import 'package:yoga_app/features/Notifications/views/notification_screen.dart';
import 'package:yoga_app/features/profile/views/my_profile_screen.dart';
import 'package:yoga_app/features/search/views/search_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // context.read<DashboardCubit>().changeDashboard(0);
    super.initState();
  }

  void _backToHome() {
    // context.read<HomeBloc>().add(HomeInitialEvent());
    context.read<DashboardCubit>().changeDashboard(0);
  }

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return BlocListener<DashboardBloc, DashboardState>(
      child: BlocBuilder<DashboardCubit, int>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (state == 0) {
                SystemNavigator.pop();
              } else {
                _backToHome();
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              appBar: state == 0
                  ? null
                  : AppBar(
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        onPressed: _backToHome,
                        icon: Image.asset(
                          AppImages.goBack,
                          height: 32,
                        ),
                      ),
                      title: Text(
                        state == 1
                            ? 'Search'
                            : state == 2
                                ? 'My Bookings'
                                : 'My Profile',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: mobile ? null : 26),
                      ),
                    ),
              drawer: const SideMenu(),
              body: state == 0
                  ? const HomeScreen()
                  : state == 1
                      ? const SearchScreen()
                      : state == 2
                          ? const MyBookingsScreen()
                          : const MyProfileScreen(),
              bottomNavigationBar: const BottomNavbar(),
            ),
          );
        },
      ),
      listener: (context, state) {
        if (state is SideMenuButtonClickedState) {
          _scaffoldKey.currentState!.openDrawer();
        } else if (state is NotificationButtonClickedState) {
          Nav.push(context, const NotificationScreen());
        } else if (state is LogoutAlertState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.logout,
                    height: 60,
                  ),
                  const VerticalSpace(height: 20),
                  Text('Do you want to Logout?',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const VerticalSpace(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          onPressed: () {
                            Nav.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ),
                      const HorizontalSpace(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            Nav.pop(context);
                            context
                                .read<DashboardBloc>()
                                .add(LogoutButtonClickedEvent());
                          },
                          child: const Text('Yes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is LogoutLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is LogoutSuccessState) {
          AppIndicators.showToast(context, state.data.message);
          UserHelper.logoutApp(context);
        } else if (state is LogoutExpiredState) {
          AppIndicators.showToast(context, state.error);
          UserHelper.logoutApp(context);
        } else if (state is LogoutFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.error.reason);
        }
      },
    );
  }
}
