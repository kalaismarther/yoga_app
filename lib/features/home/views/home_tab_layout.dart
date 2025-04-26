import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/home/components/yoga_item.dart';
import 'package:yoga_app/features/home/models/yoga_item_model.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/features/purchase/views/yoga_detail_screen.dart';
import 'package:yoga_app/features/search/bloc/search_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/no_internet.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class HomeTabLayout extends StatelessWidget {
  const HomeTabLayout({super.key});

  @override
  Widget build(BuildContext context) {
    bool lightMode = Theme.of(context).brightness == Brightness.light;
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeNavigationState,
      buildWhen: (previous, current) => current is! HomeNavigationState,
      builder: (context, state) {
        if (state is HomeInitialState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 310,
                      child: Container(
                        width: DeviceSize.screenWidth(context),
                        height: 300,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 50,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.homeBg),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HorizontalSpace(width: 10),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<DashboardBloc>()
                                        .add(SideMenuButtonClickedEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Image.asset(AppImages.menuIcon,
                                        height: 22),
                                  ),
                                ),
                                const HorizontalSpace(width: 18),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome',
                                      style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    const VerticalSpace(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: LoadingShimmer(
                                        height: 20,
                                        width: 200,
                                        baseColor: Colors.grey.shade300
                                            .withOpacity(0.3),
                                        highlightColor: Colors.grey.shade200,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<DashboardBloc>()
                                    .add(NotificationButtonClickedEvent());
                              },
                              icon: Image.asset(
                                AppImages.notificationIcon,
                                height: 56,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: DeviceSize.screenWidth(context) * 0.14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (lightMode)
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                spreadRadius: 6,
                                blurRadius: 20,
                                offset: Offset.fromDirection(1.5, 16.0),
                              )
                          ],
                        ),
                        child: TextFormField(
                          readOnly: true,
                          style: const TextStyle(fontSize: 24),
                          onTap: () {
                            context.read<DashboardCubit>().changeDashboard(1);
                            context
                                .read<SearchBloc>()
                                .add(SearchYogaEvent(keyword: ''));
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            constraints: BoxConstraints(
                              maxWidth: DeviceSize.screenWidth(context) * 0.60,
                              minWidth: 80,
                              minHeight: 60,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Image.asset(
                                AppImages.lens,
                                height: 20,
                              ),
                            ),
                            hintText: 'Search',
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle!
                                .copyWith(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const VerticalSpace(height: 20),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.44,
                      crossAxisCount: 3,
                      crossAxisSpacing: 34,
                      mainAxisSpacing: 34),
                  itemBuilder: (context, index) => Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: lightMode
                          ? const Border()
                          : Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline),
                    ),
                    child: LoadingShimmer(
                      height: double.infinity,
                      width: double.infinity,
                      baseColor: Theme.of(context).colorScheme.tertiary,
                      highlightColor: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
                const VerticalSpace(height: 28),
              ],
            ),
          );
        } else if (state is HomeSuccessState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 310,
                      child: Container(
                        width: DeviceSize.screenWidth(context),
                        height: 300,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 50,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.homeBg),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HorizontalSpace(width: 10),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<DashboardBloc>()
                                        .add(SideMenuButtonClickedEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Image.asset(AppImages.menuIcon,
                                        height: 22),
                                  ),
                                ),
                                const HorizontalSpace(width: 18),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome',
                                      style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    const VerticalSpace(height: 4),
                                    Text(
                                      '${state.data.userName} !',
                                      style: GoogleFonts.poppins(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<DashboardBloc>()
                                    .add(NotificationButtonClickedEvent());
                              },
                              icon: Image.asset(
                                AppImages.notificationIcon,
                                height: 56,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: DeviceSize.screenWidth(context) * 0.14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (lightMode)
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                spreadRadius: 6,
                                blurRadius: 20,
                                offset: Offset.fromDirection(1.5, 16.0),
                              )
                          ],
                        ),
                        child: TextFormField(
                          readOnly: true,
                          style: const TextStyle(fontSize: 24),
                          onTap: () {
                            context.read<DashboardCubit>().changeDashboard(1);
                            context
                                .read<SearchBloc>()
                                .add(SearchYogaEvent(keyword: ''));
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            constraints: BoxConstraints(
                              maxWidth: DeviceSize.screenWidth(context) * 0.60,
                              minWidth: 80,
                              minHeight: 60,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Image.asset(
                                AppImages.lens,
                                height: 20,
                              ),
                            ),
                            hintText: 'Search',
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle!
                                .copyWith(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const VerticalSpace(height: 42),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: state.data.yogaCoursesList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.44,
                      crossAxisCount: 3,
                      crossAxisSpacing: 34,
                      mainAxisSpacing: 34),
                  itemBuilder: (context, index) => YogaItem(
                    yoga: YogaItemModel.fromJson(
                        state.data.yogaCoursesList[index]),
                    isHome: true,
                  ),
                ),
                const VerticalSpace(height: 28),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Container(
                        width: DeviceSize.screenWidth(context),
                        height: 340,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 50),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.homeBg),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<MyProfileBloc>()
                                        .add(GetProfileEvent());
                                    context
                                        .read<DashboardBloc>()
                                        .add(SideMenuButtonClickedEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Image.asset(AppImages.menuIcon,
                                        height: 14),
                                  ),
                                ),
                                const HorizontalSpace(width: 12),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    const VerticalSpace(height: 4),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<DashboardBloc>()
                                    .add(NotificationButtonClickedEvent());
                              },
                              icon: Image.asset(
                                AppImages.notificationIcon,
                                height: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: DeviceSize.screenWidth(context) * 0.06,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (lightMode)
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                spreadRadius: 6,
                                blurRadius: 20,
                                offset: Offset.fromDirection(1.5, 16.0),
                              )
                          ],
                        ),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            constraints: BoxConstraints(
                              maxWidth: DeviceSize.screenWidth(context) * 0.88,
                              minWidth: 50,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Image.asset(
                                AppImages.lens,
                                height: 20,
                              ),
                            ),
                            hintText: 'Search',
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle!
                                .copyWith(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: lightMode
                                  ? BorderSide.none
                                  : BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (state is HomeNetworkErrorState)
                  const NoInternet()
                else if (state is HomeFailureState)
                  Text(state.error.reason)
              ],
            ),
          );
        }
      },
      listener: (context, state) {
        if (state is YogaItemClickedState) {
          Nav.push(context, const YogaDetailScreen());
        } else if (state is HomeExpiredState) {
          AppIndicators.showToast(context, state.error);
          UserHelper.logoutApp(context);
        }
      },
    );
  }
}



// ClipRRect(
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: LoadingShimmer(
//                                         height: 20,
//                                         width: 120,
//                                         baseColor: Colors.grey.shade300
//                                             .withOpacity(0.3),
//                                         highlightColor: Colors.grey.shade200,
//                                       ),
//                                     )