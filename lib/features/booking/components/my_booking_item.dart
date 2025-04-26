import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/booking/bloc/view_detail_bloc.dart';
import 'package:yoga_app/features/booking/models/my_booking_model.dart';
import 'package:yoga_app/features/booking/views/my_booking_detail_screen.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyBookingItem extends StatelessWidget {
  const MyBookingItem({super.key, required this.bookingDetail});

  final MyBookingModel bookingDetail;

  @override
  Widget build(BuildContext context) {
    bool mobile = DeviceSize.screenWidth(context) < 576;
    return GestureDetector(
      onTap: () {
        context
            .read<ViewDetailBloc>()
            .add(GetBookingDetailEvent(bookingId: bookingDetail.id));
        Nav.push(context, const MyBookingDetailScreen());
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(mobile ? 16 : 24),
        margin: EdgeInsets.only(bottom: mobile ? 16 : 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.outline),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bookingDetail.yogaName,
                    style: TextStyle(fontSize: mobile ? null : 22),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Booked on',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: mobile ? 10 : 18),
                        ),
                      ),
                      const HorizontalSpace(width: 4),
                      Expanded(
                        child: Text(
                          bookingDetail.bookedDate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: mobile ? 10 : 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            VerticalSpace(height: mobile ? 8 : 16),
            Row(
              children: [
                Text(
                  'Booking ID : ',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: mobile ? 12 : 18),
                ),
                Text(
                  ' #${bookingDetail.bookingRefNo}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: mobile ? 12 : 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            VerticalSpace(height: mobile ? 8 : 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start Date : ${bookingDetail.startDate}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: mobile ? 12 : 18),
                ),
                Text(
                  'Slot : ${bookingDetail.timeSlot}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: mobile ? 12 : 18),
                ),
              ],
            ),
            VerticalSpace(height: mobile ? 8 : 16),
            Text(
              'No of Class : ${bookingDetail.totalClasses}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: mobile ? 12 : 18),
            ),
          ],
        ),
      ),
    );
  }
}
