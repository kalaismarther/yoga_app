import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/HelpAndSupport/bloc/help_and_support_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  String mobile = '';
  String email = '';
  //
  final _messageTypeController = TextEditingController();
  final _descriptionController = TextEditingController();

  //
  final _messageTypeFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  @override
  void initState() {
    getOwnerDetails();
    super.initState();
  }

  void getOwnerDetails() async {
    var ownerDetail = await HiveServices.read('owner_details');
    setState(() {
      mobile = ownerDetail?['mobile']?.toString() ?? '';
      email = ownerDetail?['email']?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    _messageTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
          'Help and Support',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocConsumer<HelpAndSupportBloc, HelpAndSupportState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          try {
                            launchUrl(Uri(
                              scheme: 'tel',
                              path: mobile,
                            ));
                          } catch (e) {
                            //
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.phone,
                              height: 24,
                            ),
                            const HorizontalSpace(width: 12),
                            Text(mobile),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Divider(
                          thickness: 2,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          try {
                            launchUrl(Uri(
                              scheme: 'mailto',
                              path: email,
                            ));
                          } catch (e) {
                            //
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.mail,
                              height: 24,
                            ),
                            const HorizontalSpace(width: 12),
                            Text(email),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 60),
                TextFormField(
                  controller: _messageTypeController,
                  focusNode: _messageTypeFocus,
                  decoration: const InputDecoration(hintText: 'Message Type'),
                ),
                const VerticalSpace(height: 24),
                TextFormField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const VerticalSpace(height: 30),
                Button(
                    text: 'Send',
                    onPressed: () {
                      if (_messageTypeController.text.isEmpty) {
                        AppIndicators.showToast(
                            context, 'Please enter message type');
                      } else if (_descriptionController.text.isEmpty) {
                        AppIndicators.showToast(
                            context, 'Please enter description');
                      } else {
                        _messageTypeFocus.unfocus();
                        _descriptionFocus.unfocus();
                        //
                        context.read<HelpAndSupportBloc>().add(
                            SendHelpRequestEvent(
                                title: _messageTypeController.text.trim(),
                                comment: _descriptionController.text.trim()));
                      }
                    }),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is HelpRequestLoadingState) {
            AppIndicators.dialogLoader(context);
          } else if (state is HelpRequestSuccessState) {
            Nav.pop(context);
            _messageTypeController.clear();
            _descriptionController.clear();
            AppIndicators.showToast(context, state.message);
          } else if (state is HelpRequestExpiredState) {
            AppIndicators.showToast(context, state.error);
            UserHelper.logoutApp(context);
          } else if (state is HelpRequestFailureState) {
            Nav.pop(context);
            AppIndicators.showToast(context, state.error);
          }
        },
      ),
    );
  }
}
