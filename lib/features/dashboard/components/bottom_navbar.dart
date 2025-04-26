import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
// import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/features/search/bloc/search_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 576) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                currentIndex: state,
                onTap: (value) {
                  if (value == 0 && state != 0) {
                    // context.read<HomeBloc>().add(HomeInitialEvent());
                  } else if (value == 1 && state != 1) {
                    context
                        .read<SearchBloc>()
                        .add(SearchYogaEvent(keyword: ''));
                  } else if (value == 3 && state != 3) {
                    context.read<MyProfileBloc>().add(GetProfileEvent());
                  }
                  context.read<DashboardCubit>().changeDashboard(value);
                  // context
                  //     .read<DashboardBloc>()
                  //     .add(ChangeDashboardEvent(dashboardNo: value));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.home,
                      height: 20,
                    ),
                    activeIcon: Image.asset(
                      AppImages.homeActive,
                      height: 20,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.search,
                      height: 20,
                    ),
                    activeIcon: Image.asset(
                      AppImages.searchActive,
                      height: 20,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.mybookings,
                      height: 20,
                    ),
                    activeIcon: Image.asset(
                      AppImages.mybookingsActive,
                      height: 20,
                    ),
                    label: 'My Bookings',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.myprofile,
                      height: 20,
                    ),
                    activeIcon: Image.asset(
                      AppImages.myprofileActive,
                      height: 20,
                    ),
                    label: 'My Profile',
                  ),
                ],
              );
            } else {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                selectedLabelStyle: const TextStyle(fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                currentIndex: state,
                onTap: (value) {
                  if (value == 0 && state != 0) {
                    context.read<HomeBloc>().add(HomeInitialEvent());
                  } else if (value == 1 && state != 1) {
                    context
                        .read<SearchBloc>()
                        .add(SearchYogaEvent(keyword: ''));
                  } else if (value == 3 && state != 3) {
                    context.read<MyProfileBloc>().add(GetProfileEvent());
                  }
                  context.read<DashboardCubit>().changeDashboard(value);
                  // context
                  //     .read<DashboardBloc>()
                  //     .add(ChangeDashboardEvent(dashboardNo: value));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.home,
                      height: 34,
                    ),
                    activeIcon: Image.asset(
                      AppImages.homeActive,
                      height: 34,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.search,
                      height: 34,
                    ),
                    activeIcon: Image.asset(
                      AppImages.searchActive,
                      height: 34,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.mybookings,
                      height: 34,
                    ),
                    activeIcon: Image.asset(
                      AppImages.mybookingsActive,
                      height: 34,
                    ),
                    label: 'My Bookings',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      AppImages.myprofile,
                      height: 34,
                    ),
                    activeIcon: Image.asset(
                      AppImages.myprofileActive,
                      height: 34,
                    ),
                    label: 'My Profile',
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
