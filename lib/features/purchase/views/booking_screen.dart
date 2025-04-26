import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yoga_app/features/purchase/models/summary_view_model.dart';
import 'package:yoga_app/features/purchase/views/booking_summary_screen.dart';
import 'package:yoga_app/features/purchase/models/duration_model.dart';
import 'package:yoga_app/features/purchase/models/time_slot_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_success_model.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.yogaDetail});

  final YogaDetailSuccessModel yogaDetail;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _startDateController = TextEditingController();
  DateTime? selectedDate;
  DurationModel? selectedDuration;
  TimeSlotModel? selectedTiming;

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Nav.pop(context);
          },
          icon: Image.asset(
            AppImages.goBack,
            height: mobile ? 32 : 70,
          ),
        ),
        title: Text(
          'Booking',
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
            image: AssetImage(AppImages.bookingBg),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(mobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking for ${widget.yogaDetail.name}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: mobile ? null : 20),
              ),
              const VerticalSpace(height: 10),
              Text(
                'Duration',
                style: TextStyle(fontSize: mobile ? null : 24),
              ),
              VerticalSpace(height: mobile ? 10 : 18),
              if (mobile)
                GridView.builder(
                  itemCount: widget.yogaDetail.durationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final thisDuration = widget.yogaDetail.durationList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDuration = thisDuration;
                          selectedDate = null;
                          _startDateController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedDuration == thisDuration
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              thisDuration.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: selectedDuration == thisDuration
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                            ),
                            Text(
                              widget.yogaDetail.isFreeClassAvailable &&
                                      thisDuration.free
                                  ? 'Free'
                                  : '₹ ${thisDuration.amount}',
                              style: TextStyle(
                                  color: selectedDuration ==
                                          widget.yogaDetail.durationList[index]
                                      ? Colors.white
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              else
                GridView.builder(
                    itemCount: widget.yogaDetail.durationList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2.8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      final thisDuration =
                          widget.yogaDetail.durationList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDuration = thisDuration;
                            selectedDate = null;
                            _startDateController.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedDuration == thisDuration
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                thisDuration.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        fontSize: 16,
                                        color: selectedDuration == thisDuration
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                              ),
                              Text(
                                widget.yogaDetail.isFreeClassAvailable &&
                                        thisDuration.free
                                    ? 'Free'
                                    : '₹ ${thisDuration.amount}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: selectedDuration ==
                                            widget
                                                .yogaDetail.durationList[index]
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              VerticalSpace(height: mobile ? 20 : 34),
              Text(
                'Preferred Start Date',
                style: TextStyle(fontSize: mobile ? null : 24),
              ),
              VerticalSpace(height: mobile ? 10 : 18),
              SizedBox(
                width: mobile ? null : DeviceSize.screenWidth(context) * 0.5,
                child: TextFormField(
                  readOnly: true,
                  controller: _startDateController,
                  style: mobile ? null : const TextStyle(fontSize: 22),
                  onTap: () async {
                    if (selectedDuration == null) {
                      AppIndicators.showToast(
                          context, 'Please select duration');
                    } else {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().add(
                          const Duration(hours: 30),
                        ),
                        lastDate: selectedDuration!.free
                            ? DateTime.now().add(const Duration(days: 10))
                            : DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          _startDateController.text =
                              DateFormat('dd MMM, yyyy').format(date);
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose date',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Image.asset(
                        AppImages.calendar,
                        height: 14,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    constraints: mobile
                        ? null
                        : const BoxConstraints(
                            minHeight: 60,
                          ),
                  ),
                ),
              ),
              VerticalSpace(height: mobile ? 20 : 34),
              Text(
                'Slot',
                style: TextStyle(fontSize: mobile ? null : 24),
              ),
              VerticalSpace(height: mobile ? 10 : 18),
              if (mobile)
                GridView.builder(
                  itemCount: widget.yogaDetail.timings.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTiming = widget.yogaDetail.timings[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selectedTiming == widget.yogaDetail.timings[index]
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.yogaDetail.timings[index].timing,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: selectedTiming ==
                                        widget.yogaDetail.timings[index]
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  itemCount: widget.yogaDetail.timings.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3.6,
                      mainAxisSpacing: mobile ? 10 : 20,
                      crossAxisSpacing: mobile ? 10 : 20,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTiming = widget.yogaDetail.timings[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selectedTiming == widget.yogaDetail.timings[index]
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.yogaDetail.timings[index].timing,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontSize: mobile ? null : 18,
                                color: selectedTiming ==
                                        widget.yogaDetail.timings[index]
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              const VerticalSpace(height: 20)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(mobile ? 14 : 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            // selectedDuration?.free == true
            //     ? Text(
            //         'Free',
            //         style: TextStyle(fontSize: mobile ? null : 30),
            //       )
            //     : Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           // Text(
            //           //   'Price',
            //           //   style: Theme.of(context)
            //           //       .textTheme
            //           //       .titleSmall!
            //           //       .copyWith(fontSize: mobile ? null : 24),
            //           // ),
            //           // const VerticalSpace(height: 4),
            //           // Text(
            //           //   '₹ ${selectedDuration != null && selectedDuration?.free == false ? selectedDuration!.amount : '0'}',
            //           //   style: TextStyle(fontSize: mobile ? null : 30),
            //           // ),
            //         ],
            //       ),
            InkWell(
              onTap: () {
                if (selectedDuration == null) {
                  AppIndicators.showToast(context, 'Please select duration');
                } else if (_startDateController.text.isEmpty) {
                  AppIndicators.showToast(
                      context, 'Please select your preferred start date');
                } else if (selectedTiming == null) {
                  AppIndicators.showToast(context, 'Please select time slot');
                } else {
                  Nav.push(
                    context,
                    BookingSummaryScreen(
                      summary: SummaryViewModel(
                          selectedYoga: widget.yogaDetail,
                          selectedDuration: selectedDuration!,
                          preferredStartDate: _startDateController.text,
                          selectedTime: selectedTiming!),
                    ),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Book Now',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white, fontSize: mobile ? null : 24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
