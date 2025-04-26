import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/Auth/models/verification_success_model.dart';
import 'package:yoga_app/features/auth/views/login_screen.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/profile/bloc/update_profile_bloc.dart';
import 'package:yoga_app/features/profile/models/update_profile_request_model.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/utils/regex.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen(
      {super.key, required this.verificationSuccessResponse});

  final VerificationSuccessModel verificationSuccessResponse;
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  //KEYS
  final _updateProfileFormKey = GlobalKey<FormState>();

  //CONTROLLERS
  final _nameController = TextEditingController();
  // final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _cityController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _healthIssuesController = TextEditingController();
  final _yogaKnowledgeController = TextEditingController();
  final _surgeryController = TextEditingController();
  int gender = 0;

  @override
  void dispose() {
    _nameController.dispose();
    // _emailController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _healthIssuesController.dispose();
    _yogaKnowledgeController.dispose();
    _surgeryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
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
              'Update Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Form(
                key: _updateProfileFormKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 576) {
                      return _mobileLayout();
                    } else {
                      return _tabLayout();
                    }
                  },
                )),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(14),
            child: Button(
              text: 'Update Profile',
              onPressed: () {
                if (_updateProfileFormKey.currentState!.validate()) {
                  var input = UpdateProfileRequestModel(
                    userId: widget.verificationSuccessResponse.userData.userId,
                    apiToken:
                        widget.verificationSuccessResponse.userData.apiToken,
                    name: _nameController.text.trim(),
                    // email: _emailController.text.trim(),
                    dob: DateFormat('yyyy-MM-dd').format(
                        DateFormat('dd-MM-yyyy').parse(_dobController.text)),
                    gender: gender == 1
                        ? 'Male'
                        : gender == 2
                            ? 'Female'
                            : '',
                    occupation: _occupationController.text.trim(),
                    city: _cityController.text.trim(),
                    weight: _weightController.text.trim(),
                    height: _heightController.text.trim(),
                    healthIssues: _healthIssuesController.text.trim(),
                    previousYogaKnowledge: _yogaKnowledgeController.text.trim(),
                    surgery: _surgeryController.text.trim(),
                  );

                  context
                      .read<UpdateProfileBloc>()
                      .add(UpdateProfileButtonPressedEvent(input: input));
                }
              },
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is UpdateProfileLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is UpdateProfileSuccessState) {
          Nav.pop(context);
          if (state.redirectToHomePage == true) {
            AppIndicators.showToast(
                context, 'Profile updated. Please login again to continue');
            Nav.clearAndGo(context, const LoginScreen(), '/login_screen');
          } else {
            AppIndicators.showToast(context, state.data.message);
            Nav.push(context, const DashboardScreen());
          }
        } else if (state is UpdateProfileExpiredState) {
          Nav.pop(context);
          UserHelper.logoutApp(context);
        } else if (state is UpdateProfileFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.reason.error);
        }
      },
    );
  }

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              ' *',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
        const VerticalSpace(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter your name'),
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

        // //
        // Row(
        //   children: [
        //     Text(
        //       'Email',
        //       style: Theme.of(context).textTheme.titleMedium,
        //     ),
        //     Text(
        //       ' *',
        //       style: TextStyle(color: Theme.of(context).colorScheme.error),
        //     ),
        //   ],
        // ),
        // const VerticalSpace(height: 8),
        // TextFormField(
        //   controller: _emailController,
        //   keyboardType: TextInputType.emailAddress,
        //   decoration: const InputDecoration(hintText: 'Enter Email'),
        //   validator: (value) {
        //     if (value == null || value.trim().isEmpty) {
        //       return 'Please enter your email';
        //     } else if (!Regex.emailRegex.hasMatch(value.trim())) {
        //       return 'Invalid email';
        //     } else {
        //       return null;
        //     }
        //   },
        // ),
        // const VerticalSpace(height: 20),

        //
        Row(
          children: [
            Text(
              'Date of Birth',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Text(
            //   ' *',
            //   style: TextStyle(color: Theme.of(context).colorScheme.error),
            // ),
          ],
        ),
        const VerticalSpace(height: 8),
        TextFormField(
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now().subtract(const Duration(days: 1)),
            );
            if (date != null) {
              setState(() {
                _dobController.text = DateFormat('dd-MM-yyyy').format(date);
              });
            }
          },
          controller: _dobController,
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
            //   style: TextStyle(color: Theme.of(context).colorScheme.error),
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
            //   style: TextStyle(color: Theme.of(context).colorScheme.error),
            // ),
          ],
        ),
        const VerticalSpace(height: 8),
        TextFormField(
          controller: _occupationController,
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
            //   style: TextStyle(color: Theme.of(context).colorScheme.error),
            // ),
          ],
        ),
        const VerticalSpace(height: 8),
        TextFormField(
          controller: _cityController,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context).textTheme.titleMedium,
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
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                  const VerticalSpace(height: 8),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter Weight',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your weight';
                      } else if (!Regex.numberRegex.hasMatch(value.trim())) {
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
                        style: Theme.of(context).textTheme.titleMedium,
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
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                  const VerticalSpace(height: 8),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter Height',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your height';
                      } else if (!Regex.numberRegex.hasMatch(value.trim())) {
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
          decoration: const InputDecoration(
            hintText: 'Enter Surgery or Fracture',
          ),
        ),
        const VerticalSpace(height: 20),
      ],
    );
  }

  Widget _tabLayout() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        constraints: BoxConstraints(minHeight: 62),
                      ),
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
                    const VerticalSpace(height: 28),

                    // //
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Email',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .titleMedium!
                    //           .copyWith(fontSize: 20),
                    //     ),
                    //     Text(
                    //       ' *',
                    //       style: TextStyle(
                    //           color: Theme.of(context).colorScheme.error),
                    //     ),
                    //   ],
                    // ),
                    // const VerticalSpace(height: 12),
                    // TextFormField(
                    //   controller: _emailController,
                    //   keyboardType: TextInputType.emailAddress,
                    //   style: const TextStyle(fontSize: 20),
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter Email',
                    //     constraints: BoxConstraints(minHeight: 62),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Please enter your email';
                    //     } else if (!Regex.emailRegex.hasMatch(value.trim())) {
                    //       return 'Invalid email';
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    // ),
                    // const VerticalSpace(height: 28),

                    //
                    Row(
                      children: [
                        Text(
                          'Date of Birth',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        // Text(
                        //   ' *',
                        //   style: TextStyle(
                        //       color: Theme.of(context).colorScheme.error),
                        // ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      readOnly: true,
                      style: const TextStyle(fontSize: 20),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate:
                              DateTime.now().subtract(const Duration(days: 1)),
                        );
                        if (date != null) {
                          setState(() {
                            _dobController.text =
                                DateFormat('dd-MM-yyyy').format(date);
                          });
                        }
                      },
                      controller: _dobController,
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
                        constraints: const BoxConstraints(minHeight: 62),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.trim().isEmpty) {
                      //     return 'Please select date of birth';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),
                    const VerticalSpace(height: 28),

                    //
                    Row(
                      children: [
                        Text(
                          'Gender',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                    const VerticalSpace(height: 40),

                    //
                    Row(
                      children: [
                        Text(
                          'Occupation',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        // Text(
                        //   ' *',
                        //   style: TextStyle(
                        //       color: Theme.of(context).colorScheme.error),
                        // ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _occupationController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter Occupation',
                        constraints: BoxConstraints(minHeight: 62),
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
                  ],
                ),
              ),
              const HorizontalSpace(width: 26),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Row(
                      children: [
                        Text(
                          'City',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        // Text(
                        //   ' *',
                        //   style: TextStyle(
                        //       color: Theme.of(context).colorScheme.error),
                        // ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _cityController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter City',
                        constraints: BoxConstraints(minHeight: 62),
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
                    const VerticalSpace(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Weight',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        const HorizontalSpace(width: 4),
                        Text(
                          '(Kg)',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 14),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter Weight',
                        constraints: BoxConstraints(minHeight: 62),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your weight';
                        } else if (!Regex.numberRegex.hasMatch(value.trim())) {
                          return 'Invalid weight';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const VerticalSpace(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Height',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                        const HorizontalSpace(width: 4),
                        Text(
                          '(cm)',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 14),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter Height',
                        constraints: BoxConstraints(minHeight: 62),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your height';
                        } else if (!Regex.numberRegex.hasMatch(value.trim())) {
                          return 'Invalid height';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const VerticalSpace(height: 28),

                    //
                    Text(
                      'Health Issues if any',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _healthIssuesController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter Health Issues',
                        constraints: BoxConstraints(minHeight: 62),
                      ),
                    ),
                    const VerticalSpace(height: 28),

                    //
                    Text(
                      'Previous Knowledge of Yoga',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    ),
                    const VerticalSpace(height: 12),
                    TextFormField(
                      controller: _yogaKnowledgeController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: 'Enter Previous Knowledge',
                        constraints: BoxConstraints(minHeight: 62),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VerticalSpace(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'If Surgery or Fracture Made',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 20),
              ),
              const HorizontalSpace(width: 4),
              Text(
                '(in Past 12 months)',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
          const VerticalSpace(height: 12),
          TextFormField(
            controller: _surgeryController,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              hintText: 'Enter Surgery or Fracture',
              constraints: BoxConstraints(minHeight: 62),
            ),
          ),
          const VerticalSpace(height: 20),
        ],
      ),
    );
  }
}
