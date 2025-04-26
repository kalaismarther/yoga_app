import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/features/Auth/models/login_request_model.dart';
import 'package:yoga_app/features/auth/bloc/login_bloc.dart';
import 'package:yoga_app/features/auth/views/terms_and_conditions_screen.dart';
import 'package:yoga_app/features/auth/views/verification_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/utils/regex.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loginWithMobile = true;
  bool agreed = false;
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _mobileFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoadingState) {
              AppIndicators.dialogLoader(context);
            } else if (state is LoginSuccessState) {
              Nav.pop(context);
              Nav.push(
                  context,
                  VerificationScreen(
                      userLoginData: state.data, forLogin: true));
            } else if (state is LoginFailureState) {
              Nav.pop(context);
              AppIndicators.showToast(context, state.reason.error);
            }
          },
          builder: (context, state) => SingleChildScrollView(
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VerticalSpace(
                                height: DeviceSize.screenHeight(context) * 0.2),
                            Text(
                              'Login',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const VerticalSpace(height: 30),
                            Text(
                              loginWithMobile
                                  ? 'Mobile Number'
                                  : 'Email Address',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const VerticalSpace(height: 10),
                            TextFormField(
                              maxLength: loginWithMobile ? 10 : null,
                              controller: _mobileController,
                              focusNode: _mobileFocus,
                              keyboardType: loginWithMobile
                                  ? TextInputType.number
                                  : TextInputType.emailAddress,
                              decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: loginWithMobile
                                      ? Row(
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
                                        )
                                      : Icon(
                                          Icons.email_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.4),
                                        ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loginWithMobile
                                      ? 'Please enter mobile number'
                                      : 'Please enter email address';
                                } else {
                                  if (loginWithMobile) {
                                    if (value.trim().length < 10 ||
                                        !Regex.numberRegex
                                            .hasMatch(value.trim())) {
                                      return 'Invalid mobile number';
                                    }
                                    return null;
                                  } else {
                                    if (!Regex.emailRegex
                                        .hasMatch(value.trim())) {
                                      return 'Invalid email address';
                                    }
                                    return null;
                                  }
                                }
                              },
                            ),
                            const VerticalSpace(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: agreed,
                                  onChanged: (value) => setState(() {
                                    agreed = value!;
                                  }),
                                ),
                                Text(
                                  'I agree',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Nav.push(context,
                                        const TermsAndConditionsScreen());
                                  },
                                  child: const Text('Terms & Conditions'),
                                ),
                              ],
                            ),
                            const VerticalSpace(height: 12),
                            Button(
                              text: 'Login',
                              onPressed: () {
                                _mobileFocus.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  if (agreed) {
                                    context.read<LoginBloc>().add(
                                        LoginButtonPressedEvent(
                                            input: LoginRequestModel(
                                                mobileNo:
                                                    _mobileController.text)));
                                  } else {
                                    AppIndicators.showToast(context,
                                        'Please agree our terms and conditions');
                                  }
                                }
                              },
                            ),
                            const VerticalSpace(height: 10),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  _mobileFocus.unfocus();
                                  setState(() {
                                    loginWithMobile = !loginWithMobile;
                                    if (loginWithMobile &&
                                        (!Regex.numberRegex.hasMatch(
                                                _mobileController.text
                                                    .trim()) ||
                                            _mobileController.text
                                                    .trim()
                                                    .length !=
                                                10)) {
                                      _mobileController.clear();
                                    } else if (!loginWithMobile &&
                                        !Regex.emailRegex.hasMatch(
                                            _mobileController.text.trim())) {
                                      _mobileController.clear();
                                    }
                                  });
                                  _formKey.currentState?.validate();
                                },
                                child: Text(
                                    'Login with ${loginWithMobile ? 'Email' : 'Mobile number'} '),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
