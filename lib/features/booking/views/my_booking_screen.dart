import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/booking/bloc/my_booking_bloc.dart';
import 'package:yoga_app/features/booking/components/my_booking_item.dart';
import 'package:yoga_app/features/booking/components/my_booking_loading.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int type = 1;

  @override
  void initState() {
    context.read<MyBookingBloc>().add(GetMyBookingsEvent(type: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return BlocConsumer<MyBookingBloc, MyBookingState>(
      listener: (context, state) {
        if (state is MyBookingExpiredState) {
          AppIndicators.showToast(context, state.error);
          UserHelper.logoutApp(context);
        }
      },
      builder: (context, state) {
        if (state is MyBookingsListLoadingState) {
          return MyBookingLoading(currentType: type);
        } else {
          return Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.mybookingBg),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(mobile ? 16 : 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              type = 1;
                            });
                            context
                                .read<MyBookingBloc>()
                                .add(GetMyBookingsEvent(type: type));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: type == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ongoing',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: mobile ? null : 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const HorizontalSpace(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              type = 0;
                            });
                            context
                                .read<MyBookingBloc>()
                                .add(GetMyBookingsEvent(type: type));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: type == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Completed',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: mobile ? null : 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(height: mobile ? 14 : 20),
                  if (state is MyBookingsListSuccessState)
                    ListView.builder(
                      itemCount: state.data.mybookingsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => MyBookingItem(
                        bookingDetail: state.data.mybookingsList[index],
                      ),
                    )
                  else if (state is MyBookingsListFailureState)
                    Center(
                      child: Text(state.error.reason),
                    )
                  else
                    const SizedBox()
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
