import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_app/features/Auth/models/login_success_model.dart';
import 'package:yoga_app/features/auth/views/verification_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/utils/regex.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class ChangeCredentialScreen extends StatefulWidget {
  const ChangeCredentialScreen({super.key, required this.forChangingEmail});

  final bool forChangingEmail;

  @override
  State<ChangeCredentialScreen> createState() => _ChangeCredentialScreenState();
}

class _ChangeCredentialScreenState extends State<ChangeCredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _mobileFieldFocus = FocusNode();

  bool loginWithEmail = true;

  @override
  void initState() {
    setState(() {
      loginWithEmail = widget.forChangingEmail;
    });
    _mobileController.addListener(() {
      if (_mobileController.text.length == 10) {
        _mobileFieldFocus.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _mobileFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    AppImages.loginBanner,
                    height: DeviceSize.screenHeight(context) * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpace(
                            height: DeviceSize.screenHeight(context) * 0.2),
                        Text(
                          loginWithEmail
                              ? 'Update Email'
                              : 'Update Mobile Number',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 16),
                        ),
                        const VerticalSpace(height: 30),
                        // Text(loginWithEmail ? 'Email Address' : 'Mobile Number',
                        //     style: Theme.of(context).textTheme.titleSmall),
                        // const VerticalSpace(height: 14),
                        TextFormField(
                          controller: _mobileController,
                          focusNode: _mobileFieldFocus,
                          maxLength: loginWithEmail ? null : 10,
                          keyboardType: loginWithEmail
                              ? TextInputType.emailAddress
                              : const TextInputType.numberWithOptions(),
                          inputFormatters: loginWithEmail
                              ? null
                              : [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            counterText: '',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: loginWithEmail
                                  ? Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.6),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          AppImages.mobileIcon,
                                          height: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        const HorizontalSpace(width: 6),
                                        Text(
                                          '+91',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )
                                      ],
                                    ),
                            ),
                          ),
                          onTapOutside: (event) {},
                          validator: (value) {
                            if (loginWithEmail) {
                              if (value == null || value.isEmpty) {
                                return 'Enter email address';
                              } else if (!Regex.emailRegex
                                  .hasMatch(value.trim())) {
                                return 'Invalid email address';
                              } else {
                                return null;
                              }
                            } else {
                              if (value == null || value.isEmpty) {
                                return 'Enter mobile number';
                              } else if (!Regex.numberRegex
                                      .hasMatch(value.trim()) ||
                                  value.trim().length < 10) {
                                return 'Invalid mobile number';
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                        const VerticalSpace(height: 16),
                        Button(
                          text: 'Submit',
                          onPressed: () {
                            _mobileFieldFocus.unfocus();
                            if (_formKey.currentState!.validate()) {
                              Nav.replace(
                                  context,
                                  VerificationScreen(
                                      userLoginData: LoginSuccessModel(
                                          message: '',
                                          data: _mobileController.text),
                                      forLogin: false));
                            }
                          },
                        ),
                        const VerticalSpace(height: 8),
                      ],
                    ),
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
