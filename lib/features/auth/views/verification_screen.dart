import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:yoga_app/features/Auth/bloc/verification_bloc.dart';
import 'package:yoga_app/features/Auth/models/login_success_model.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/profile/views/update_profile_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(
      {super.key, required this.userLoginData, required this.forLogin});

  final LoginSuccessModel userLoginData;
  final bool forLogin;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _otpFieldFocus = FocusNode();

  //FOR OTP TIMER
  late Timer timer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    _otpTimer();
    super.initState();
  }

  void _otpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationBloc, VerificationState>(
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 576) {
            return _mobileLayout();
          } else {
            return _tabLayout();
          }
        },
      ),
      listener: (context, state) {
        if (state is VerificationLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is NewUserState) {
          if (widget.forLogin) {
            Nav.pop(context);
            AppIndicators.showToast(
                context, 'Update profile to create account');
            Nav.replace(
                context,
                UpdateProfileScreen(
                  verificationSuccessResponse: state.data,
                ));
          } else {
            Nav.pop(context);
            Navigator.of(context).pop(true);
          }
        } else if (state is ExistingUserState) {
          if (widget.forLogin) {
            Nav.pop(context);
            Nav.replace(context, const DashboardScreen());
          } else {
            Nav.pop(context);
            Navigator.of(context).pop(true);
            AppIndicators.showToast(context, state.data.message);
          }
        } else if (state is VerificationFailureState) {
          if (widget.forLogin) {
            Nav.pop(context);
            AppIndicators.showToast(context, state.reason.error);
          } else {
            Navigator.of(context).pop(false);
            AppIndicators.showToast(context, state.reason.error);
          }
        } else if (state is ResendOtpSuccessState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.data.message);
          setState(() {
            _remainingSeconds = 60;
          });
          _otpTimer();
        } else if (state is ResendOtpFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.error.reason);
        }
      },
    );
  }

  Widget _mobileLayout() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: DeviceSize.screenHeight(context),
              width: DeviceSize.screenWidth(context),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.verificationBanner,
                    height: DeviceSize.screenHeight(context) * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: DeviceSize.screenHeight(context) * 0.7,
                width: DeviceSize.screenWidth(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Theme.of(context).brightness == Brightness.light
                            ? AppImages.curvedWhiteImage
                            : AppImages.curvedBlackImage,
                      ),
                      fit: BoxFit.fill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpace(
                          height: DeviceSize.screenHeight(context) * 0.2),
                      Text(
                        'Verification',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const VerticalSpace(height: 30),
                      Form(
                        key: _formKey,
                        child: Pinput(
                          length: 4,
                          controller: _otpController,
                          focusNode: _otpFieldFocus,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          defaultPinTheme: PinTheme(
                            width: 64,
                            height: 62,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 64,
                            height: 62,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.outline,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          errorPinTheme: PinTheme(
                            width: 64,
                            height: 62,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.error),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter OTP';
                            } else if (value.length < 4) {
                              return 'Please enter  4 digit OTP';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                          onCompleted: (value) {},
                        ),
                      ),
                      const VerticalSpace(height: 20),
                      if (_remainingSeconds != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend code in ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '$_remainingSeconds secs',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ],
                          ),
                        )
                      else
                        Center(
                            child: TextButton(
                          onPressed: () {
                            context.read<VerificationBloc>().add(
                                ResendButtonPressedEvent(
                                    mobileNo: widget.userLoginData.data));
                          },
                          child: Text(
                            'Resend OTP',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )),
                      const VerticalSpace(height: 20),
                      Button(
                        text: 'Verify OTP',
                        onPressed: () {
                          // Nav.push(context, const UpdateProfileScreen());
                          _otpFieldFocus.unfocus();
                          if (_formKey.currentState!.validate()) {
                            context.read<VerificationBloc>().add(
                                  VerificationButtonPressedEvent(
                                    mobNo: widget.userLoginData.data,
                                    otp: _otpController.text,
                                    forLogin: widget.forLogin,
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabLayout() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: DeviceSize.screenHeight(context),
              width: DeviceSize.screenWidth(context),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.verificationBanner,
                    height: DeviceSize.screenHeight(context) * 0.50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: DeviceSize.screenHeight(context) * 0.64,
                width: DeviceSize.screenWidth(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        Theme.of(context).brightness == Brightness.light
                            ? AppImages.curvedWhiteImage
                            : AppImages.curvedBlackImage,
                      ),
                      fit: BoxFit.fill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpace(
                          height: DeviceSize.screenHeight(context) * 0.2),
                      Text(
                        'Verification',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontSize: 46),
                      ),
                      const VerticalSpace(height: 36),
                      Form(
                        key: _formKey,
                        child: Center(
                          child: Pinput(
                            length: 4,
                            controller: _otpController,
                            focusNode: _otpFieldFocus,
                            mainAxisAlignment: MainAxisAlignment.center,
                            defaultPinTheme: PinTheme(
                              width: 94,
                              height: 94,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: TextStyle(
                                  fontSize: 40,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 94,
                              height: 94,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(1, 2),
                                  )
                                ],
                              ),
                              textStyle: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            errorPinTheme: PinTheme(
                              width: 94,
                              height: 94,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter OTP';
                              } else if (value.length < 4) {
                                return 'Please enter  4 digit OTP';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {},
                            onCompleted: (value) {},
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 26),
                      if (_remainingSeconds != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend code in ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 20),
                              ),
                              Text(
                                '$_remainingSeconds secs',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 20),
                              ),
                            ],
                          ),
                        )
                      else
                        Center(
                            child: TextButton(
                          onPressed: () {
                            context.read<VerificationBloc>().add(
                                ResendButtonPressedEvent(
                                    mobileNo: widget.userLoginData.data));
                          },
                          child: Text(
                            'Resend OTP',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 20),
                          ),
                        )),
                      const VerticalSpace(height: 20),
                      Button(
                        text: 'Verify OTP',
                        onPressed: () {
                          // Nav.push(context, const UpdateProfileScreen());
                          _otpFieldFocus.unfocus();
                          if (_formKey.currentState!.validate()) {
                            context.read<VerificationBloc>().add(
                                  VerificationButtonPressedEvent(
                                    mobNo: widget.userLoginData.data,
                                    otp: _otpController.text,
                                    forLogin: widget.forLogin,
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
