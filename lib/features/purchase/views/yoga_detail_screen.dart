import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/purchase/views/booking_screen.dart';
import 'package:yoga_app/features/purchase/bloc/yoga_detail_bloc.dart';
import 'package:yoga_app/features/purchase/components/yoga_detail_loading.dart';
import 'package:yoga_app/features/SwitchCourse/views/switching_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/widgets/loading_shimmer.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class YogaDetailScreen extends StatefulWidget {
  const YogaDetailScreen({super.key}) : bookingId = null;

  const YogaDetailScreen.forSwitchOver({super.key, required this.bookingId});

  final int? bookingId;

  @override
  State<YogaDetailScreen> createState() => _YogaDetailScreenState();
}

class _YogaDetailScreenState extends State<YogaDetailScreen> {
  // final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // List<ProductDetails> products = [];

  @override
  void initState() {
    // _loadProducts();
    super.initState();
  }

  // void _loadProducts() async {
  //   print("Checking availability of In-App Purchases...");
  //   bool available = await _inAppPurchase.isAvailable();
  //   if (!available) {
  //     print("In-App Purchases are not available on this device.");
  //     return;
  //   }

  //   print(available);

  //   const Set<String> productIds = {
  //     'power_yoga_one_month',
  //     'therapy_yoga_1_month'
  //   };
  //   print("Product IDs: $productIds");

  //   print("Querying product details...");
  //   final ProductDetailsResponse response =
  //       await _inAppPurchase.queryProductDetails(productIds);

  //   if (response.error != null) {
  //     print("Error during query: ${response.error!.message}");
  //     return;
  //   }

  //   if (response.notFoundIDs.isNotEmpty) {
  //     print("Products not found: ${response.notFoundIDs}");
  //   } else {
  //     print("Products fetched successfully: ${response.productDetails}");
  //   }

  //   products = response.productDetails;
  //   print("Final product list: $products");
  // }

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return BlocConsumer<YogaDetailBloc, YogaDetailState>(
      builder: (context, state) {
        if (state is YogaDetailInitialState) {
          return const YogaDetailLoading();
        } else if (state is YogaDetailSuccessState) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: state.data.headerImageLink,
                      placeholder: (context, url) => Container(
                        clipBehavior: Clip.hardEdge,
                        height: DeviceSize.screenHeight(context) * 0.4,
                        width: DeviceSize.screenWidth(context),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: LoadingShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          baseColor: Theme.of(context).colorScheme.tertiary,
                          highlightColor:
                              Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: DeviceSize.screenHeight(context) * 0.4,
                        width: DeviceSize.screenWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 46,
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          Nav.pop(context);
                        },
                        icon: Image.asset(
                          AppImages.backArrowWhite,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 22,
                      left: 20,
                      child: Text(
                        state.data.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white, fontSize: mobile ? null : 30),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.detailBg),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About the Yoga',
                            style: TextStyle(fontSize: mobile ? null : 24),
                          ),
                          const VerticalSpace(height: 10),
                          ExpandableText(
                            state.data.about,
                            expandText: 'show more',
                            collapseText: 'show less',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: mobile ? null : 20),
                            linkColor: Colors.blue,
                            maxLines: 3,
                          ),
                          const VerticalSpace(height: 30),
                          Text(
                            'Available Days',
                            style: TextStyle(fontSize: mobile ? null : 24),
                          ),
                          VerticalSpace(height: mobile ? 18 : 26),
                          SizedBox(
                            height: mobile ? 20 : 30,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: VerticalDivider(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              itemCount: state.data.days.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Text(
                                state.data.days[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: mobile ? 12 : 20),
                              ),
                            ),
                          ),
                          VerticalSpace(height: mobile ? 30 : 50),
                          Text(
                            'Available Timings',
                            style: TextStyle(fontSize: mobile ? null : 24),
                          ),
                          VerticalSpace(height: mobile ? 10 : 26),
                          GridView.builder(
                            itemCount: state.data.timings.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 7,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.data.timings[index].timing,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(fontSize: mobile ? 12 : 22),
                                    ),
                                  ),
                                ),
                                if (index % 2 == 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: VerticalDivider(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const VerticalSpace(height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(14),
              child: (widget.bookingId != null && state.data.isOngoingcourse) ||
                      state.data.isOngoingcourse
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: mobile ? null : const EdgeInsets.all(18)),
                      onPressed: () {},
                      child: Text(
                        'Booked!',
                        style: TextStyle(fontSize: mobile ? null : 24),
                      ),
                    )
                  : Button(
                      text: widget.bookingId != null ? 'Switch' : 'Book Now',
                      onPressed: () async {
                        if (state.data.isOngoingcourse) {
                          context.read<DashboardCubit>().changeDashboard(2);
                          Nav.push(context, const DashboardScreen());
                        } else if (widget.bookingId != null) {
                          Nav.replace(
                            context,
                            SwitchingScreen(
                              bookingId: widget.bookingId!,
                              yogaDetail: state.data,
                            ),
                          );
                        } else {
                          Nav.push(
                            context,
                            BookingScreen(
                              yogaDetail: state.data,
                            ),
                          );
                        }
                      },
                    ),
            ),
          );
        } else if (state is YogaDetailFailureState) {
          return Text(state.error);
        } else {
          return Container();
        }
      },
      listener: (context, state) {
        if (state is YogaDetailSessionExpiredState) {
          AppIndicators.showToast(context, state.error);
          UserHelper.logoutApp(context);
        }
      },
    );
  }
}
