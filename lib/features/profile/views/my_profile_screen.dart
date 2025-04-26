import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_app/Helper/date_helper.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/profile/bloc/delete_account_bloc.dart';
import 'package:yoga_app/features/profile/bloc/my_profile_bloc.dart';
import 'package:yoga_app/features/profile/components/my_profile_loading.dart';
import 'package:yoga_app/features/profile/views/edit_profile_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
      // buildWhen: (previous, current) => current is ProfileDetailState,
      builder: (context, state) {
        if (state is ProfileDetailLoadingState) {
          return const MyProfileLoading();
        } else if (state is ProfileDetailState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const VerticalSpace(height: 20),
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
                      baseColor: Theme.of(context).colorScheme.tertiary,
                      highlightColor: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
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
                const VerticalSpace(height: 30),
                TextFormField(
                  readOnly: true,
                  initialValue: state.profileData.name,
                ),
                const VerticalSpace(height: 20),
                if (state.profileData.email.isNotEmpty) ...[
                  TextFormField(
                    readOnly: true,
                    initialValue: state.profileData.email,
                  ),
                  const VerticalSpace(height: 20),
                ],
                if (state.profileData.mobile.isNotEmpty) ...[
                  TextFormField(
                    readOnly: true,
                    initialValue: state.profileData.mobile,
                  ),
                  const VerticalSpace(height: 20),
                ],
                TextFormField(
                  readOnly: true,
                  initialValue:
                      DateHelper.ddmmmyyyyStringFormat(state.profileData.dob),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Image.asset(
                        AppImages.calendar,
                        height: 14,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 20),
                if (state.profileData.city.isNotEmpty)
                  TextFormField(
                    readOnly: true,
                    initialValue: state.profileData.city,
                  ),
                const VerticalSpace(height: 30),
                Button(
                  text: 'Edit Profile',
                  onPressed: () async {
                    context.read<MyProfileBloc>().add(GetProfileEvent());
                    await Nav.push(context, const EditProfileScreen());
                  },
                ),
                const VerticalSpace(height: 10),
                if (state.showDeleteIcon == true)
                  BlocListener<DeleteAccountBloc, DeleteAccountState>(
                    listener: (context, state) {
                      if (state is DeleteAccountLoading) {
                        AppIndicators.dialogLoader(context);
                      } else if (state is DeleteAccountSuccess) {
                        Nav.pop(context);
                        UserHelper.logoutApp(context);
                        AppIndicators.showToast(
                            context, 'Account Deleted Successfully');
                      }
                      if (state is DeleteAccountExpired) {
                        Nav.pop(context);
                        UserHelper.logoutApp(context);
                      }
                      if (state is DeleteAccountFailed) {
                        Nav.pop(context);
                        AppIndicators.showToast(context, state.error);
                      }
                    },
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text(
                                'Are you sure to delete your account?. This action will erase all of your data permanently.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Nav.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Nav.pop(context);
                                  context
                                      .read<DeleteAccountBloc>()
                                      .add(DeleteMyAccountEvent());
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      label: const Text('Delete My Account'),
                      icon: const Icon(Icons.delete_outline, size: 20),
                    ),
                  )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
      listener: (context, state) {},
    );
  }
}
