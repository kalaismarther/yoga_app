import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/Testimonials/bloc/testimonial_bloc.dart';
import 'package:yoga_app/features/Testimonials/components/testimonial_item.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';

class TestimonialScreen extends StatelessWidget {
  const TestimonialScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Reviews',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocConsumer<TestimonialBloc, TestimonialState>(
                builder: (context, state) {
                  if (state is TestimonialLoadingState) {
                    return ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        height: 200,
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
                      ),
                    );
                  } else if (state is TestimonialSuccessState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.testimonials.length,
                      itemBuilder: (context, index) => TestimonialItem(
                        testimonial: state.testimonials[index],
                      ),
                    );
                  } else if (state is TestimonialFailureState) {
                    return Center(
                      child: Text(state.error),
                    );
                  } else {
                    return Container();
                  }
                },
                listener: (context, state) {
                  if (state is TestimonialExpiredState) {
                    AppIndicators.showToast(context, state.error);
                    UserHelper.logoutApp(context);
                  }
                },
              )
            ],
          ),
        ));
  }
}
