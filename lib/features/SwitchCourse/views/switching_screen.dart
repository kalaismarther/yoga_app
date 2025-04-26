import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/SwitchCourse/bloc/switch_course_bloc.dart';
import 'package:yoga_app/features/booking/bloc/view_detail_bloc.dart';
import 'package:yoga_app/features/purchase/models/time_slot_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_success_model.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class SwitchingScreen extends StatefulWidget {
  const SwitchingScreen(
      {super.key, required this.bookingId, required this.yogaDetail});

  final int bookingId;
  final YogaDetailSuccessModel yogaDetail;

  @override
  State<SwitchingScreen> createState() => _SwitchingScreenState();
}

class _SwitchingScreenState extends State<SwitchingScreen> {
  //
  TimeSlotModel? selectedTiming;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwitchCourseBloc, SwitchCourseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Nav.pop(context);
              },
              icon: Image.asset(
                AppImages.goBack,
                height: 32,
              ),
            ),
            title: Text(
              'Switching',
              style: Theme.of(context).textTheme.titleLarge,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Switching to ${widget.yogaDetail.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const VerticalSpace(height: 10),
                  const Text('Slot'),
                  const VerticalSpace(height: 10),
                  GridView.builder(
                    itemCount: widget.yogaDetail.timings.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20)
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Button(
              text: 'Send Request',
              onPressed: () {
                if (selectedTiming == null) {
                  AppIndicators.showSnackbar(
                      context, 'Please select time slot');
                } else {
                  context.read<SwitchCourseBloc>().add(
                      SendRequestButtonClickedEvent(
                          bookingId: widget.bookingId,
                          newClassId: widget.yogaDetail.id,
                          timeSlotId: selectedTiming!.id));
                }
              },
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is SwitchCourseLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is SwitchCourseSuccessState) {
          Nav.pop(context);
          context
              .read<ViewDetailBloc>()
              .add(GetBookingDetailEvent(bookingId: widget.bookingId));
          Nav.pop(context);
          AppIndicators.showToast(context, state.data.message);
        } else if (state is SwitchCourseFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.error.reason);
        }
      },
    );
  }
}
