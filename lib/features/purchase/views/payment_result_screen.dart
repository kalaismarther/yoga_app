import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:yoga_app/Helper/user_helper.dart';
import 'package:yoga_app/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:yoga_app/features/dashboard/views/dashboard_screen.dart';
import 'package:yoga_app/features/purchase/bloc/payment_bloc.dart';
import 'package:yoga_app/utils/app_images.dart';
import 'package:yoga_app/utils/navigations.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({
    super.key,
    required this.orderId,
    required this.orderRefNo,
    required this.amount,
  });

  final int orderId;
  final String orderRefNo;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc()
        ..add(InitiatePaymentEvent(
            orderId: orderId, amount: amount, orderRefNo: orderRefNo)),
      child: Scaffold(
        body: BlocConsumer<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is UpdatePaymentFailed) {
              return failed(context);
            } else if (state is UpdatePaymentSuccess) {
              return success(context);
            } else {
              return processing(context);
            }
          },
          listener: (context, state) {
            if (state is UpdatePaymentExpired) {
              UserHelper.logoutApp(context);
            }
          },
        ),
      ),
    );
  }

  Widget processing(BuildContext context) => PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWaveSpinner(
              size: 150,
              color: Theme.of(context).colorScheme.primary,
              waveColor: Colors.deepOrange.shade200,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Processing payment. Please wait',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Don\'t close the screen or exit the app',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
      );

  Widget success(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            context.read<DashboardCubit>().changeDashboard(2);
            Nav.clearAndGo(
                context, const DashboardScreen(), '/dashboard_screen');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: LottieBuilder.asset(
                AppImages.paymentSuccess,
                repeat: false,
              ),
            ),
            const SizedBox(height: 28),
            const Center(
              child: Text(
                'Payment successful',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                context.read<DashboardCubit>().changeDashboard(2);
                Nav.clearAndGo(
                    context, const DashboardScreen(), '/dashboard_screen');
              },
              child: Text(
                'View my bookings',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.green),
              ),
            )
          ],
        ),
      );

  Widget failed(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            Nav.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: LottieBuilder.asset(
                    AppImages.paymentFailed,
                    repeat: false,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Payment Failed',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        maximumSize: const Size(double.infinity, 50),
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // context.read<CheckoutBloc>().add(ClearStateEvent());
                        Nav.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        maximumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<PaymentBloc>().add(InitiatePaymentEvent(
                            orderId: orderId,
                            amount: amount,
                            orderRefNo: orderRefNo));
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
