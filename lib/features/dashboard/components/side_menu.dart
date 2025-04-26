import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/HelpAndSupport/views/help_and_support_screen.dart';
import 'package:yoga_app/features/Testimonials/bloc/testimonial_bloc.dart';
import 'package:yoga_app/features/Testimonials/views/testimonial_screen.dart';
import 'package:yoga_app/features/auth/views/privacy_policy_screen.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/dashboard/views/about_us_screen.dart';
import 'package:yoga_app/features/Notifications/views/notification_screen.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  void initState() {
    context.read<MyProfileBloc>().add(GetProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          BlocBuilder<MyProfileBloc, MyProfileState>(
            buildWhen: (previous, current) => current is ProfileDetailState,
            builder: (context, state) {
              if (state is ProfileDetailState) {
                return Container(
                  padding: const EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: ListTile(
                    onTap: () {
                      Nav.pop(context);
                      context.read<DashboardCubit>().changeDashboard(3);
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    leading: CachedNetworkImage(
                      imageUrl: state.profileData.profileImage,
                      placeholder: (context, url) => Container(
                        clipBehavior: Clip.hardEdge,
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: LoadingShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          baseColor: Theme.of(context).colorScheme.primary,
                          highlightColor: Colors.grey.shade300.withOpacity(0.3),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      state.profileData.name,
                      style: Theme.of(context)
                          .listTileTheme
                          .titleTextStyle!
                          .copyWith(
                              fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    subtitle: Text(
                      state.profileData.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          ListTile(
            onTap: () {
              Nav.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smHome,
              height: 18,
            ),
            title: const Text('Home'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              Nav.pop(context);
              context.read<DashboardCubit>().changeDashboard(2);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smMyBooking,
              height: 18,
            ),
            title: const Text('My Booking'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          ListTile(
            onTap: () {
              context.read<MyProfileBloc>().add(GetProfileEvent());
              Nav.pop(context);
              context.read<DashboardCubit>().changeDashboard(3);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smMyProfile,
              height: 20,
            ),
            title: const Text('My Profile'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          ListTile(
            onTap: () {
              Nav.pop(context);
              Nav.push(context, const NotificationScreen());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smNotification,
              height: 18,
            ),
            title: const Text('Notification'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              Nav.pop(context);
              context.read<TestimonialBloc>().add(GetTestimonialsEvent());
              Nav.push(context, const TestimonialScreen());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.star,
              height: 18,
            ),
            title: const Text('Client Feedbacks'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              Nav.push(context, const AboutUsScreen());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smAbout,
              height: 18,
            ),
            title: const Text('About Us'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              Nav.push(context, const PrivacyPolicyScreen());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smAbout,
              height: 18,
            ),
            title: const Text('Privacy Policy'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              Nav.pop(context);
              Nav.push(context, const HelpAndSupportScreen());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smHelp,
              height: 18,
            ),
            title: const Text('Help & Support'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          //
          ListTile(
            onTap: () {
              context.read<DashboardBloc>().add(ShowLogoutAlertEvent());
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: Image.asset(
              AppImages.smLogout,
              height: 18,
            ),
            title: const Text('Logout'),
            trailing: Image.asset(
              AppImages.rightArrow,
              height: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
