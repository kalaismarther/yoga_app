import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:yoga_app/Services/payment_service.dart';
// import 'package:yoga_app/widgets/button.dart';
import 'package:yoga_app/Helper/date_helper.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/purchase/bloc/booking_bloc.dart';
import 'package:yoga_app/features/purchase/models/summary_view_model.dart';
import 'package:yoga_app/features/purchase/views/payment_result_screen.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/app_indicators.dart';
import 'package:yoga_app/utils/device_size.dart';
import 'package:yoga_app/utils/navigations.dart';
import 'package:yoga_app/widgets/horizontal_space.dart';
import 'package:yoga_app/widgets/vertical_space.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key, required this.summary});

  final SummaryViewModel summary;

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late Stream<List<PurchaseDetails>> _purchaseStream;
  List<ProductDetails> products = [];
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    _purchaseStream = _inAppPurchase.purchaseStream;
    _listenToPurchaseUpdates();
    _loadProducts();
  }

  // Fetch the product details
  void _loadProducts() async {
    Set<String> productIds = {
      '${widget.summary.selectedYoga.classProductId}_${widget.summary.selectedDuration.durationProductId}'
          .toLowerCase()
    };
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("Products not found: ${response.notFoundIDs}");
    } else if (response.error != null) {
      print("Error fetching products: ${response.error!.message}");
    } else {
      setState(() {
        products = response.productDetails;
      });
    }
  }

  // Listen to purchase updates
  void _listenToPurchaseUpdates() {
    _purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      for (final PurchaseDetails purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.pending) {
          // Show a loading indicator
          print('Purchase is pending...');
        } else if (purchase.status == PurchaseStatus.error) {
          // Handle the error
          print('Error: ${purchase.error?.message}');
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          // Verify purchase and deliver the product
          _verifyPurchase(purchase);
        }

        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
      }
    }, onError: (error) {
      print('Purchase stream error: $error');
    });
  }

  // Verify and deliver the purchase
  void _verifyPurchase(PurchaseDetails purchase) {
    context.read<BookingBloc>().add(
          MakePaymentButtonClickedEvent(
            classId: widget.summary.selectedYoga.id,
            durationId: widget.summary.selectedDuration.id,
            timeslotId: widget.summary.selectedTime.id,
            startDate: DateHelper.yyyymmddStringFormat(
              widget.summary.preferredStartDate,
            ),
            isIos: 1,
          ),
        );
  }

  // Buy a product
  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    //
    bool mobile = DeviceSize.screenWidth(context) < 576;
    //
    return BlocConsumer<BookingBloc, BookingState>(
      buildWhen: (previous, current) => current is! InAppPurchaseState,
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
              'Booking',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.summaryBg),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(mobile ? 16 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mobile) _mobileLayout() else _tabLayout(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(mobile ? 14 : 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.summary.selectedDuration.free
                    ? Text(
                        'Free',
                        style: TextStyle(fontSize: mobile ? null : 30),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Price',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: mobile ? null : 24),
                          ),
                          const VerticalSpace(height: 4),
                          Text(
                            '₹ ${widget.summary.selectedDuration.free ? '0' : widget.summary.selectedDuration.amount}',
                            style: TextStyle(fontSize: mobile ? null : 30),
                          ),
                        ],
                      ),
                InkWell(
                  onTap: () {
                    if (widget.summary.selectedYoga.inAppPurchase &&
                        Platform.isIOS) {
                      if (products.isNotEmpty) {
                        _buyProduct(products.first);
                      } else {
                        AppIndicators.showToast(context, 'Product Not Found');
                      }
                      // context.read<BookingBloc>().add(InAppPurchaseEvent(
                      //     productId:
                      //         '${widget.summary.selectedYoga.classProductId}_${widget.summary.selectedDuration.durationProductId}'));
                      return;
                    } else {
                      context.read<BookingBloc>().add(
                            MakePaymentButtonClickedEvent(
                                classId: widget.summary.selectedYoga.id,
                                durationId: widget.summary.selectedDuration.id,
                                timeslotId: widget.summary.selectedTime.id,
                                startDate: DateHelper.yyyymmddStringFormat(
                                    widget.summary.preferredStartDate),
                                isIos: 0),
                          );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.summary.selectedDuration.free
                          ? 'Enroll Now'
                          : 'Make Payment',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: mobile ? null : 24,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        // if (state is InAppPurchaseSuccess) {
        //   context.read<BookingBloc>().add(
        //         MakePaymentButtonClickedEvent(
        //           classId: widget.summary.selectedYoga.id,
        //           durationId: widget.summary.selectedDuration.id,
        //           timeslotId: widget.summary.selectedTime.id,
        //           startDate: DateHelper.yyyymmddStringFormat(
        //             widget.summary.preferredStartDate,
        //           ),
        //           isIos: 1,
        //         ),
        //       );
        // }
        // if (state is InAppPurchaseFailure) {
        //   AppIndicators.showToast(context, state.error);
        // }
        if (state is BookingLoadingState) {
          AppIndicators.dialogLoader(context);
        } else if (state is BookingSuccessState) {
          Nav.pop(context);
          double courseAmount = double.parse(
              widget.summary.selectedDuration.amount.replaceAll(',', ''));

          if (state.data.isFreeClass) {
            AppIndicators.showToast(context, 'Class Enrolled Successfully');
            context.read<DashboardCubit>().changeDashboard(2);
            Nav.clearAndGo(
                context, const DashboardScreen(), '/dashboard-screen');
          } else {
            Nav.push(
                context,
                PaymentResultScreen(
                    orderId: state.data.bookingSummaryId,
                    orderRefNo: state.data.bookingRefNo,
                    amount: courseAmount));
          }
        } else if (state is BookingFailureState) {
          Nav.pop(context);
          AppIndicators.showToast(context, state.error.failureMessage);
        } else if (state is BookingExpiredState) {
          AppIndicators.showToast(context, state.error);
          UserHelper.logoutApp(context);
        } else if (state is PaymentLoadingState) {
          AppIndicators.paymentLoadingDialog(context);
        }
      },
    );
  }

  Widget _mobileLayout() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Booking Summary'),
              const VerticalSpace(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.summary.selectedYoga.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    const HorizontalSpace(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Classes',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            widget.summary.selectedDuration.duration,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpace(height: 12),
              Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 1.6,
              ),
              const VerticalSpace(height: 8),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          AppImages.calendars,
                          height: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const VerticalSpace(height: 14),
                        Image.asset(
                          AppImages.clock,
                          height: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    const HorizontalSpace(width: 24),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.outline,
                      thickness: 1.6,
                    ),
                    const HorizontalSpace(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.summary.preferredStartDate,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const VerticalSpace(height: 16),
                        Text(
                          widget.summary.selectedTime.timing,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const VerticalSpace(height: 20),
        if (!widget.summary.selectedDuration.free)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pricing Summary'),
                const VerticalSpace(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '₹ ${widget.summary.selectedDuration.free ? '0' : widget.summary.selectedDuration.amount}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const VerticalSpace(height: 8),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 1.6,
                ),
                const VerticalSpace(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount Payable',
                    ),
                    Row(
                      children: [
                        Text(
                          '₹ ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          widget.summary.selectedDuration.free
                              ? '0'
                              : widget.summary.selectedDuration.amount,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _tabLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outline, width: 2.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(fontSize: 24),
                  ),
                  const VerticalSpace(height: 20),
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.summary.selectedYoga.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        const HorizontalSpace(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Classes',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: 20),
                              ),
                              Text(
                                widget.summary.selectedDuration.duration,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(height: 12),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                    thickness: 2,
                  ),
                  const VerticalSpace(height: 8),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.calendars,
                              height: 28,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const VerticalSpace(height: 14),
                            Image.asset(
                              AppImages.clock,
                              height: 28,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ],
                        ),
                        const HorizontalSpace(width: 24),
                        VerticalDivider(
                          color: Theme.of(context).colorScheme.outline,
                          thickness: 2,
                        ),
                        const HorizontalSpace(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.summary.preferredStartDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
                            ),
                            const VerticalSpace(height: 16),
                            Text(
                              widget.summary.selectedTime.timing,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const HorizontalSpace(width: 20),
          if (!widget.summary.selectedDuration.free)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline, width: 2.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pricing Summary',
                      style: TextStyle(fontSize: 20),
                    ),
                    const VerticalSpace(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 20),
                        ),
                        Text(
                          '₹ ${widget.summary.selectedDuration.free ? '0' : widget.summary.selectedDuration.amount}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Divider(
                            color: Theme.of(context).colorScheme.outline,
                            thickness: 2,
                          ),
                          const VerticalSpace(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Amount Payable',
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹ ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 24),
                                  ),
                                  Text(
                                    widget.summary.selectedDuration.free
                                        ? '0'
                                        : widget
                                            .summary.selectedDuration.amount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Colors.green, fontSize: 24),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
