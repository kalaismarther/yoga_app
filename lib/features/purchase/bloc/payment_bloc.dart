import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/Services/payment_service.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/purchase/models/payment_request_model.dart';
import 'package:yoga_app/features/purchase/repo/purchase_api.dart';
part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Razorpay _razorpay = Razorpay();
  int orderId = 0;
  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) {});

    void handlePaymentSuccess(PaymentSuccessResponse response) {
      add(UpdatePaymentEvent(
          orderId: orderId, paymentGatewayResponse: response.paymentId));
    }

    void handlePaymentError(PaymentFailureResponse response) {
      add(PaymentFailureEvent(' ${response.message ?? 'Payment failed.'}'));
    }

    void handleExternalWallet(ExternalWalletResponse response) {}

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    on<InitiatePaymentEvent>((event, emit) async {
      try {
        orderId = event.orderId;

        emit(UpdatePaymentLoading());
        var userDetail = await HiveServices.read('user_detail');
        ProfileDetailModel user = ProfileDetailModel.fromJson(userDetail);

        int amount = (event.amount * 100).toInt();

        var options = {
          'key': PaymentService.key,
          // 'order_id': event.orderId,
          'amount': amount,
          'name': 'Yoga Park Therapy Centre',
          'description': event.orderRefNo,
          'prefill': {'contact': user.mobile, 'email': user.email}
        };

        print(options);

        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
        emit(UpdatePaymentFailed(error: e.toString()));
      }
    });

    on<UpdatePaymentEvent>((event, emit) async {
      try {
        emit(UpdatePaymentLoading());

        final userDetail = await HiveServices.read('user_detail');

        final user = ProfileDetailModel.fromJson(userDetail);
        var input = PaymentRequestModel(
            userId: user.userId,
            bookingSummaryId: event.orderId,
            paymentId: event.paymentGatewayResponse ?? '',
            paymentStatus: 'PAID',
            apiToken: user.apiToken);

        print(input);

        final apiRequest = await PurchaseApi.updatePaymentStatus(input: input);

        if (apiRequest.success) {
          if (apiRequest.data['status'].toString() == '1') {
            emit(UpdatePaymentSuccess());
          } else if (apiRequest.data['status'].toString() == '2') {
            emit(UpdatePaymentFailed(
                error: apiRequest.data['message'] ?? 'Session Expired'));
          } else {
            emit(UpdatePaymentFailed(error: apiRequest.data['message'] ?? ''));
          }
        } else {
          emit(UpdatePaymentFailed(error: apiRequest.errorMessage ?? ''));
        }
      } catch (e) {
        emit(UpdatePaymentFailed(error: e.toString()));
      }
    });

    on<PaymentSuccessEvent>((event, emit) {
      emit(UpdatePaymentSuccess());
    });

    on<PaymentFailureEvent>((event, emit) {
      print(event.reason);
      emit(UpdatePaymentFailed(error: event.reason));
    });
  }
}
