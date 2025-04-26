import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:yoga_app/features/Notifications/bloc/notification_bloc.dart';
import 'package:yoga_app/features/Notifications/components/notification_item.dart';
import 'package:yoga_app/features/Notifications/cubit/notification_cubit.dart';
import 'package:yoga_app/features/Notifications/models/notification_model.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';

import 'package:yoga_app/widgets/loading_shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const route = '/notification-screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    context.read<NotificationCubit>().page = 0;
    context.read<NotificationCubit>().getNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<NotificationCubit>().getNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          ModalRoute.withName('/dashboard_screen'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
                ModalRoute.withName('/dashboard_screen'),
              );
            },
            icon: Image.asset(
              AppImages.goBack,
              height: mobile ? 32 : 70,
            ),
          ),
          title: Text(
            'Notification',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: mobile ? null : 28),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          // buildWhen: (previous, current) => current is! PaginationFailureState,
          // listener: (context, state) {
          //   if (state is NotificationsExpiredState) {
          //     AppIndicators.showToast(context, state.error);
          //     UserHelper.logoutApp(context);
          //   }
          //   if (state is PaginationFailureState) {
          //     AppIndicators.showToast(context, 'No more notifications');
          //   }
          // },
          builder: (context, state) {
            if (state is NotificationsLoading && state.isFirstFetch) {
              return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) => Container(
                        height: 80,
                        clipBehavior: Clip.hardEdge,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            if (Theme.of(context).brightness ==
                                Brightness.light)
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(1, 2),
                              )
                          ],
                        ),
                        child: LoadingShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          baseColor: Theme.of(context).colorScheme.tertiary,
                          highlightColor:
                              Theme.of(context).colorScheme.onTertiary,
                        ),
                      ));
            }
            if (state is NotificationsFailureState && state.isFirstFetch) {
              return Center(
                child: Text(state.error),
              );
            }
            List<NotificationModel> notifications = [];
            bool isLoading = false;

            if (state is NotificationsFailureState) {
              isLoading = false;
            }

            if (state is NotificationsLoading) {
              notifications = state.oldNotifications;
              isLoading = true;
            }
            if (state is NotificationsLoadedState) {
              notifications = state.notifications;
            }

            return notifications.isEmpty
                ? const Center(
                    child: Text('No notifications'),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount:
                                notifications.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < notifications.length) {
                                return NotificationItem(
                                  notification: notifications[index],
                                );
                              } else {
                                return const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                              }
                            }),
                        // if (state is PaginationLoadingState)
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
