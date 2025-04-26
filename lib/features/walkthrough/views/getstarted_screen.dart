import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/auth/views/login_screen.dart';
import 'package:yoga_app/features/walkthrough/bloc/walk_through_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';

class GetstartedScreen extends StatefulWidget {
  const GetstartedScreen({super.key});

  @override
  State<GetstartedScreen> createState() => _GetstartedScreenState();
}

class _GetstartedScreenState extends State<GetstartedScreen> {
  //
  @override
  void initState() {
    context.read<WalkThroughBloc>().add(GetWalkThroughContentEvent());
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          SystemNavigator.pop();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 576) {
              return _mobileLayout();
            } else {
              return _tabLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _mobileLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: DeviceSize.screenHeight(context),
              width: DeviceSize.screenWidth(context),
            ),
            Positioned(
              bottom: 200,
              child: Image.asset(
                AppImages.curvedLine,
                height: 276,
                width: DeviceSize.screenWidth(context),
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: DeviceSize.screenHeight(context) * 0.66,
                        maxWidth: 316),
                    child: BlocBuilder<WalkThroughBloc, WalkThroughState>(
                      builder: (context, state) {
                        if (state is WalkThroughSuccessState) {
                          return CarouselView(
                            backgroundColor: Colors.transparent,
                            itemExtent: 316,
                            itemSnapping: true,
                            children: [
                              for (final banner in state.data.banners)
                                Column(
                                  children: [
                                    Image.network(
                                      banner.imageLink,
                                      height: 316,
                                      width: 316,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banner.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          const SizedBox(height: 24),
                                          Text(banner.description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                            ],
                          );
                        } else if (state is WalkThroughLoadingState) {
                          return const SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is WalkThroughFailureState) {
                          return SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: Text(state.error.reason),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  Button(
                    text: 'Get Started',
                    onPressed: () {
                      Nav.push(context, const LoginScreen());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const LoginScreen(),
                      //   ),
                      // );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: DeviceSize.screenHeight(context),
              width: DeviceSize.screenWidth(context),
            ),
            Positioned(
              bottom: 200,
              child: Image.asset(
                AppImages.curvedLine,
                height: 276,
                width: DeviceSize.screenWidth(context),
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: DeviceSize.screenHeight(context) * 0.72,
                        maxWidth: 550),
                    child: BlocBuilder<WalkThroughBloc, WalkThroughState>(
                      builder: (context, state) {
                        if (state is WalkThroughSuccessState) {
                          return CarouselView(
                            backgroundColor: Colors.transparent,
                            itemExtent: 550,
                            itemSnapping: true,
                            children: [
                              for (final banner in state.data.banners)
                                Column(
                                  children: [
                                    Image.network(
                                      banner.imageLink,
                                      height: 550,
                                      width: 550,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banner.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(fontSize: 54),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            banner.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(fontSize: 26),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                            ],
                          );
                        } else if (state is WalkThroughLoadingState) {
                          return const SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is WalkThroughFailureState) {
                          return SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(
                              child: Text(state.error.reason),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Button(
                      text: 'Get Started',
                      onPressed: () {
                        Nav.push(
                          context,
                          const LoginScreen(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
