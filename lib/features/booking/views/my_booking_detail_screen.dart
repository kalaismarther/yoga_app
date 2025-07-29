import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yoga_app/Helper/user_helper.dart';
// import 'package:yoga_app/features/booking/bloc/my_booking_bloc.dart';
import 'package:yoga_app/features/booking/bloc/view_detail_bloc.dart';
import 'package:yoga_app/features/booking/components/view_detail_loading.dart';
import 'package:yoga_app/features/home/bloc/home_bloc.dart';
import 'package:yoga_app/features/home/models/yoga_item_model.dart';
import 'package:yoga_app/features/purchase/bloc/yoga_detail_bloc.dart';
import 'package:yoga_app/features/purchase/views/yoga_detail_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyBookingDetailScreen extends StatelessWidget {
  const MyBookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    return PopScope(
      // canPop: false,
      // onPopInvokedWithResult: (didPop, result) {
      //   if (didPop) {
      //     return;
      //   }
      //   context.read<MyBookingBloc>().add(GetMyBookingsEvent(type: 1));
      //   Nav.pop(context);
      // },
      canPop: true,

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              // context.read<MyBookingBloc>().add(GetMyBookingsEvent(type: 1));
              Nav.pop(context);
            },
            icon: Image.asset(
              AppImages.goBack,
              height: mobile ? 32 : 70,
            ),
          ),
          title: Text(
            'View Details',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: mobile ? null : 28),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.summaryBg),
            ),
          ),
          child: BlocConsumer<ViewDetailBloc, ViewDetailState>(
            builder: (context, state) {
              if (state is ViewDetailLoadingState) {
                return const ViewDetailLoading();
              } else if (state is ViewDetailSuccessState) {
                var bookingDetail = state.data.bookingDetail;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: DeviceSize.screenWidth(context) * 0.42,
                                  child: const Text(
                                    'Booking Summary',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: DeviceSize.screenWidth(context) * 0.42,
                                  child: Text(
                                    '${bookingDetail.dateExpired ? 'Expired on' : 'Valid till'} ${bookingDetail.endDate}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: bookingDetail.dateExpired
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: mobile ? 12 : 16),
                                  ),
                                ),
                              ],
                            ),
                            const VerticalSpace(height: 10),
                            SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        bookingDetail.yogaName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: mobile ? null : 20),
                                      ),
                                    ),
                                  ),
                                  const HorizontalSpace(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Classes',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          bookingDetail.totalClasses.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalSpace(height: 10),
                            SizedBox(
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Attended Classes : ${bookingDetail.totalClasses - bookingDetail.remainingClasses}/${bookingDetail.totalClasses}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalSpace(height: 12),
                            Divider(
                              color: Theme.of(context).colorScheme.outline,
                              thickness: 1.6,
                            ),
                            const VerticalSpace(height: 8),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        AppImages.calendars,
                                        height: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      const VerticalSpace(height: 14),
                                      Image.asset(
                                        AppImages.clock,
                                        height: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ],
                                  ),
                                  const HorizontalSpace(width: 24),
                                  VerticalDivider(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    thickness: 1.6,
                                  ),
                                  const HorizontalSpace(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookingDetail.startDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const VerticalSpace(height: 16),
                                        Text(
                                          bookingDetail.timeSlot,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (bookingDetail.switchStatus != 1 &&
                                      !bookingDetail.dateExpired &&
                                      bookingDetail.remainingClasses > 0)
                                    InkWell(
                                      onTap: () {
                                        if (bookingDetail.dateExpired) {
                                          AppIndicators.showSnackbar(context,
                                              'The course has been expired');
                                        } else if (bookingDetail
                                                .remainingClasses ==
                                            0) {
                                          AppIndicators.showSnackbar(context,
                                              'There\'s no remaining classes');
                                        } else if (bookingDetail.switchStatus ==
                                            1) {
                                          AppIndicators.showSnackbar(context,
                                              'This yoga class is no longer available. Because you switched to another class');
                                        } else {
                                          launchUrlString(
                                              bookingDetail.zoomLink);
                                        }
                                      },
                                      child: Image.asset(
                                        AppImages.zoomLogo,
                                        height: 46,
                                        width: 46,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(height: 20),
                      if (bookingDetail.amount.trim() != '0')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pricing Summary'),
                              const VerticalSpace(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (bookingDetail.amount.trim() == '0')
                                    Text(
                                      'Free',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.green),
                                    )
                                  else
                                    Text(
                                      '₹ ${bookingDetail.amount}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                              const VerticalSpace(height: 8),
                              if (bookingDetail.amount.trim() != '0') ...[
                                Divider(
                                  color: Theme.of(context).colorScheme.outline,
                                  thickness: 1.6,
                                ),
                                const VerticalSpace(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Amount Paid'),
                                    Row(
                                      children: [
                                        Text(
                                          '₹ ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          bookingDetail.amount,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      const VerticalSpace(height: 32),
                      if (bookingDetail.switchStatus == 0 ||
                          bookingDetail.switchStatus == 3) ...[
                        if (!bookingDetail.dateExpired &&
                            bookingDetail.remainingClasses > 0)
                          // if (bookingDetail.amount.trim() == '0')
                          //   Container(
                          //     margin: const EdgeInsets.only(bottom: 14),
                          //     padding: const EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //           color:
                          //               Theme.of(context).colorScheme.outline),
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Text(
                          //       'You cannot switch to other class from free class or trial class',
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .bodySmall!
                          //           .copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .error),
                          //     ),
                          //   )
                          // else
                          if (bookingDetail.amount.trim() != '0')
                            Button(
                              text: 'Switch to other yoga',
                              onPressed: () {
                                context
                                    .read<HomeBloc>()
                                    .add(HomeInitialEvent());
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) => Container(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: Column(
                                        children: [
                                          const VerticalSpace(height: 20),
                                          const Text('Choose yoga'),
                                          if (state is HomeInitialState) ...[
                                            ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(22),
                                              itemCount: 5,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                clipBehavior: Clip.hardEdge,
                                                margin: const EdgeInsets.only(
                                                    bottom: 16),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: LoadingShimmer(
                                                  height: 24,
                                                  width: double.infinity,
                                                  baseColor: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onTertiary,
                                                ),
                                              ),
                                            )
                                          ] else if (state
                                              is HomeSuccessState) ...[
                                            Expanded(
                                              child: ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                itemCount: state.data
                                                    .yogaCoursesList.length,
                                                itemBuilder: (context, index) {
                                                  var course = YogaItemModel
                                                      .fromJson(state.data
                                                              .yogaCoursesList[
                                                          index]);
                                                  return ListTile(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              YogaDetailBloc>()
                                                          .add(GetYogaDetailEvent(
                                                              courseId: course
                                                                  .yogaId));
                                                      Nav.pop(context);
                                                      Nav.push(
                                                          context,
                                                          YogaDetailScreen
                                                              .forSwitchOver(
                                                                  bookingId:
                                                                      bookingDetail
                                                                          .id));
                                                    },
                                                    leading: Container(
                                                      height: 36,
                                                      width: 36,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.network(
                                                        course.imageLink,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    title: Text(course.name),
                                                  );
                                                },
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                      ] else
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            bookingDetail.switchStatus == 2
                                ? 'Your request for changing the class has been sent to admin'
                                : 'This yoga class is no longer available. Because you switched to another class',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      if (state.data.previousBookings.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        ExpansionTile(
                          title: Text(
                            'Previous Bookings',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          tilePadding: const EdgeInsets.all(0),
                          children: [
                            for (final previousBooking
                                in state.data.previousBookings)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(previousBooking.className),
                                        Row(
                                          children: [
                                            Text(
                                              'Booked on',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 10),
                                            ),
                                            const HorizontalSpace(width: 4),
                                            Text(
                                              previousBooking.bookedDate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const VerticalSpace(height: 8),
                                    Text(
                                      'Slot : ${previousBooking.timeSlot}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12),
                                    ),
                                    const VerticalSpace(height: 8),
                                    Text(
                                      'No of Class : ${previousBooking.totalClasses}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12),
                                    ),
                                    const VerticalSpace(height: 8),
                                    Text(
                                      'Attended Classes : ${previousBooking.totalClasses - previousBooking.remainingClasses}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ]
                    ],
                  ),
                );
              } else if (state is ViewDetailFailureState) {
                return Text(state.error.reason);
              } else {
                return Container();
              }
            },
            listener: (context, state) {
              if (state is ViewDetailExpiredState) {
                AppIndicators.showToast(context, state.error);
                UserHelper.logoutApp(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
