import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yoga_app/Helper/date_helper.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/Auth/models/login_success_model.dart';
import 'package:yoga_app/features/Auth/views/verification_screen.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/features/profile/models/edit_profile_request_model.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/utils/regex.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //KEYS
  final _formKey = GlobalKey<FormState>();

  //CONTROLLERS
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _cityController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _healthIssuesController = TextEditingController();
  final _yogaKnowledgeController = TextEditingController();
  final _surgeryController = TextEditingController();
  int gender = 0;
  DateTime? _selectedDOB;

  bool initialized = false;

  bool isEmailChanged = false;
  bool isMobileChanged = false;
  bool? mobileVerified;

  final _nameFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _dobFocus = FocusNode();
  final _occupationFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _heightFocus = FocusNode();
  final _healthIssueFocus = FocusNode();
  final _yogaKnowledgeFocus = FocusNode();
  final _surgeryFocus = FocusNode();

  Future<void> chooseImageAndGetPath({required bool openCamera}) async {
    Nav.pop(context);
    final image = await ImagePicker().pickImage(
      source: openCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      if (mounted) {
        context
            .read<MyProfileBloc>()
            .add(UpdateProfileImageEvent(imagePath: image.path));
      }
    }
  }

  void unfocusAll() {
    _nameFocus.unfocus();
    _mobileFocus.unfocus();
    _emailFocus.unfocus();
    _dobFocus.unfocus();
    _occupationFocus.unfocus();
    _cityFocus.unfocus();
    _weightFocus.unfocus();
    _heightFocus.unfocus();
    _healthIssueFocus.unfocus();
    _yogaKnowledgeFocus.unfocus();
    _surgeryFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
      buildWhen: (previous, current) => current is ProfileDetailState,
      listener: (context, state) {
        if (state is EditProfileLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is EditProfileSuccessState) {
          Nav.pop(context);
          context.read<MyProfileBloc>().add(GetProfileEvent());
          AppIndicators.showToast(context, state.message);
        } else if (state is EditProfileFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.reason.error);
          context.read<MyProfileBloc>().add(GetProfileEvent());
        } else if (state is SessionExpiredState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.reason.error);
          UserHelper.logoutApp(context);
        } else if (state is MobileNumberChangedState) {
          Nav.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationScreen(
                      userLoginData: LoginSuccessModel(
                          message: '',
                          data: isMobileChanged
                              ? _mobileController.text
                              : isEmailChanged
                                  ? _emailController.text
                                  : ''),
                      forLogin: false)));
        } else if (state is CameraIconClickedState) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.surface,
            builder: (context) => Container(
              height: 160,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      chooseImageAndGetPath(openCamera: true);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const VerticalSpace(height: 12),
                        const Text('Camera')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      chooseImageAndGetPath(openCamera: false);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const VerticalSpace(height: 12),
                        const Text('Gallery')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UpdateProfileImageSuccessState) {
          context.read<MyProfileBloc>().add(GetProfileEvent());
          Nav.pop(context);
          AppIndicators.showToast(context, state.successMessage);
        } else if (state is UpdateProfileImageFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.failureMessage);
        }
      },
      builder: (context, state) {
        if (state is ProfileDetailState) {
          if (!initialized) {
            _nameController.text = state.profileData.name;
            _mobileController.text = state.profileData.mobile;
            _emailController.text = state.profileData.email;
            _dobController.text =
                DateHelper.ddmmmyyyyStringFormat(state.profileData.dob);
            _selectedDOB =
                DateHelper.convertStringToDateFormat(state.profileData.dob);
            gender = state.profileData.gender.toLowerCase() == 'male'
                ? 1
                : state.profileData.gender.toLowerCase() == 'female'
                    ? 2
                    : 0;
            _occupationController.text = state.profileData.occupation;
            _cityController.text = state.profileData.city;
            _weightController.text = state.profileData.weight;
            _heightController.text = state.profileData.height;
            _healthIssuesController.text = state.profileData.healthIssues;
            _yogaKnowledgeController.text =
                state.profileData.previousYogaKnowledge;
            _surgeryController.text = state.profileData.surgery;
            initialized = true;
          }

          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              context.read<MyProfileBloc>().add(GetProfileEvent());
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Nav.pop(context);
                    context.read<MyProfileBloc>().add(GetProfileEvent());
                  },
                  icon: Image.asset(
                    AppImages.goBack,
                    height: 32,
                  ),
                ),
                title: Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpace(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: state.profileData.profileImage,
                              placeholder: (context, url) => Container(
                                clipBehavior: Clip.hardEdge,
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: LoadingShimmer(
                                  height: double.infinity,
                                  width: double.infinity,
                                  baseColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  highlightColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -4,
                              bottom: -8,
                              child: IconButton(
                                onPressed: () {
                                  context
                                      .read<MyProfileBloc>()
                                      .add(CameraIconClickedEvent());
                                },
                                icon: Image.asset(
                                  AppImages.cameraIcon,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(height: 30),
                      Row(
                        children: [
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        decoration:
                            const InputDecoration(hintText: 'Enter your name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          } else if (!Regex.nameRegex.hasMatch(value.trim())) {
                            return 'Invalid name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const VerticalSpace(height: 20),

                      Row(
                        children: [
                          Text(
                            'Mobile',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        // readOnly: true,
                        // onTap: () {
                        //   Nav.push(
                        //       context,
                        //       const ChangeCredentialScreen(
                        //           forChangingEmail: false));
                        // },
                        controller: _mobileController,
                        focusNode: _mobileFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'Enter your mobile',
                          counterText: '',
                          suffixIcon: isMobileChanged
                              ? TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      unfocusAll();

                                      var updatedDetail = EditProfileRequestModel(
                                          userId: state.profileData.userId,
                                          name: _nameController.text.trim(),
                                          profileImage: '',
                                          mobile: _mobileController.text.trim(),
                                          email: state.profileData.email,
                                          dob: DateHelper.yyyymmddStringFormat(
                                              _dobController.text),
                                          gender:
                                              gender == 1 ? 'Male' : 'Female',
                                          occupation:
                                              _occupationController.text.trim(),
                                          city: _cityController.text.trim(),
                                          weight: _weightController.text.trim(),
                                          height: _heightController.text.trim(),
                                          healthIssues: _healthIssuesController
                                              .text
                                              .trim(),
                                          previousYogaKnowledge:
                                              _yogaKnowledgeController.text
                                                  .trim(),
                                          surgery:
                                              _surgeryController.text.trim(),
                                          fcmToken: state.profileData.fcmToken,
                                          apiToken: state.profileData.apiToken,
                                          isProfileUpdated: state
                                              .profileData.isProfileUpdated,
                                          deviceType:
                                              state.profileData.deviceType,
                                          deviceId: state.profileData.deviceId);

                                      context.read<MyProfileBloc>().add(
                                          SaveChagesButtonClickedEvent(
                                              input: updatedDetail));
                                    }
                                  },
                                  child: const Text('Change'),
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              isMobileChanged = true;
                            } else {
                              isMobileChanged = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (isMobileChanged) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (!Regex.numberRegex
                                    .hasMatch(value.trim()) ||
                                value.length < 10) {
                              return 'Invalid mobile number';
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        // readOnly: true,
                        // onTap: () {
                        //   Nav.push(
                        //       context,
                        //       const ChangeCredentialScreen(
                        //           forChangingEmail: true));
                        // },
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          suffixIcon: isEmailChanged
                              ? TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      unfocusAll();

                                      var updatedDetail = EditProfileRequestModel(
                                          userId: state.profileData.userId,
                                          name: _nameController.text.trim(),
                                          profileImage: '',
                                          mobile: state.profileData.mobile,
                                          email: _emailController.text.trim(),
                                          dob: DateHelper.yyyymmddStringFormat(
                                              _dobController.text),
                                          gender:
                                              gender == 1 ? 'Male' : 'Female',
                                          occupation:
                                              _occupationController.text.trim(),
                                          city: _cityController.text.trim(),
                                          weight: _weightController.text.trim(),
                                          height: _heightController.text.trim(),
                                          healthIssues: _healthIssuesController
                                              .text
                                              .trim(),
                                          previousYogaKnowledge:
                                              _yogaKnowledgeController.text
                                                  .trim(),
                                          surgery:
                                              _surgeryController.text.trim(),
                                          fcmToken: state.profileData.fcmToken,
                                          apiToken: state.profileData.apiToken,
                                          isProfileUpdated: state
                                              .profileData.isProfileUpdated,
                                          deviceType:
                                              state.profileData.deviceType,
                                          deviceId: state.profileData.deviceId);

                                      context.read<MyProfileBloc>().add(
                                          SaveChagesButtonClickedEvent(
                                              input: updatedDetail));
                                    }
                                  },
                                  child: const Text('Change'),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (isEmailChanged) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            } else if (!Regex.emailRegex
                                .hasMatch(value.trim())) {
                              return 'Invalid email';
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              isEmailChanged = true;
                            } else {
                              isEmailChanged = false;
                            }
                          });
                        },
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        children: [
                          Text(
                            'Date of Birth',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDOB,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now()
                                .subtract(const Duration(days: 1)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDOB = date;
                              _dobController.text =
                                  DateFormat('dd MMM, yyyy').format(date);
                            });
                          }
                        },
                        controller: _dobController,
                        focusNode: _dobFocus,
                        decoration: InputDecoration(
                          hintText: 'Select D.O.B',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(
                              AppImages.calendar,
                              height: 14,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return 'Please select date of birth';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        children: [
                          Text(
                            'Gender',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              title: Text(
                                'Male',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: 2,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              title: Text(
                                'Female',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                        ],
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        children: [
                          Text(
                            'Occupation',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _occupationController,
                        focusNode: _occupationFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter Occupation',
                        ),
                        // validator: (value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return 'Please enter your occupation';
                        //   } else if (!Regex.nameRegex.hasMatch(value.trim())) {
                        //     return 'Invalid occupation';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        children: [
                          Text(
                            'City',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(
                          //   ' *',
                          //   style: TextStyle(
                          //       color: Theme.of(context).colorScheme.error),
                          // ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _cityController,
                        focusNode: _cityFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter City',
                        ),
                        // validator: (value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return 'Please enter your city';
                        //   } else if (!Regex.nameRegex.hasMatch(value.trim())) {
                        //     return 'Invalid city';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      const VerticalSpace(height: 20),

                      Row(
                        children: [
                          //
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Weight',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const HorizontalSpace(width: 4),
                                    Text(
                                      '(Kg)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 10),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ],
                                ),
                                const VerticalSpace(height: 8),
                                TextFormField(
                                  controller: _weightController,
                                  focusNode: _weightFocus,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Weight',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter your weight';
                                    } else if (!Regex.numberRegex
                                        .hasMatch(value.trim())) {
                                      return 'Invalid weight';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const HorizontalSpace(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Height',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const HorizontalSpace(width: 4),
                                    Text(
                                      '(cm)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 10),
                                    ),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ],
                                ),
                                const VerticalSpace(height: 8),
                                TextFormField(
                                  controller: _heightController,
                                  focusNode: _heightFocus,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Height',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter your height';
                                    } else if (!Regex.numberRegex
                                        .hasMatch(value.trim())) {
                                      return 'Invalid height';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Text(
                        'Health Issues if any',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _healthIssuesController,
                        focusNode: _healthIssueFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter Health',
                        ),
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Text(
                        'Previous Knowledge of Yoga',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _yogaKnowledgeController,
                        focusNode: _yogaKnowledgeFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter Previous Knowledge',
                        ),
                      ),
                      const VerticalSpace(height: 20),

                      //
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'If Surgery or Fracture Made',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const HorizontalSpace(width: 4),
                          Text(
                            '(in Past 12 months)',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      const VerticalSpace(height: 8),
                      TextFormField(
                        controller: _surgeryController,
                        focusNode: _surgeryFocus,
                        decoration: const InputDecoration(
                          hintText: 'Enter Surgery or Fracture',
                        ),
                      ),
                      const VerticalSpace(height: 20),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(14),
                child: Button(
                  text: 'Save Changes',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      unfocusAll();

                      var updatedDetail = EditProfileRequestModel(
                          userId: state.profileData.userId,
                          name: _nameController.text.trim(),
                          profileImage: '',
                          mobile: _mobileController.text.trim(),
                          email: _emailController.text.trim(),
                          dob: DateHelper.yyyymmddStringFormat(
                              _dobController.text),
                          gender: gender == 1 ? 'Male' : 'Female',
                          occupation: _occupationController.text.trim(),
                          city: _cityController.text.trim(),
                          weight: _weightController.text.trim(),
                          height: _heightController.text.trim(),
                          healthIssues: _healthIssuesController.text.trim(),
                          previousYogaKnowledge:
                              _yogaKnowledgeController.text.trim(),
                          surgery: _surgeryController.text.trim(),
                          fcmToken: state.profileData.fcmToken,
                          apiToken: state.profileData.apiToken,
                          isProfileUpdated: state.profileData.isProfileUpdated,
                          deviceType: state.profileData.deviceType,
                          deviceId: state.profileData.deviceId);

                      context.read<MyProfileBloc>().add(
                          SaveChagesButtonClickedEvent(input: updatedDetail));
                    }
                  },
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
