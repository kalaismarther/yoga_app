import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:yoga_app/Services/hive_service.dart';
import 'package:yoga_app/features/profile/models/profile_detail_model.dart';
import 'package:yoga_app/features/purchase/models/booking_failure_model.dart';
import 'package:yoga_app/features/purchase/models/booking_request_model.dart';
import 'package:yoga_app/features/purchase/models/booking_success_model.dart';
import 'package:yoga_app/features/purchase/models/payment_request_model.dart';
import 'package:yoga_app/features/purchase/repo/purchase_api.dart';
part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  // final InAppPurchase _iap = InAppPurchase.instance;
  BookingBloc() : super(BookingInitial()) {
    on<BookingEvent>((event, emit) {});

    // on<InAppPurchaseEvent>((event, emit) async {
    //   List<ProductDetails> products = [];
    //   Set<String> productIds = {event.productId.toLowerCase()};
    //   print(productIds);
    //   final response = await _iap.queryProductDetails(productIds);

    //   if (response.error != null) {
    //     emit(InAppPurchaseFailure(
    //         error: response.error?.message ?? "Unknown error"));
    //   } else if (response.notFoundIDs.isNotEmpty) {
    //     emit(InAppPurchaseFailure(error: "Product not found"));
    //   } else {
    //     products = response.productDetails;

    //     print(products);

    //     if (products.isNotEmpty) {
    //       try {
    //         final done = _iap.restorePurchases();
    //         print(done);

    //         _iap.purchaseStream
    //             .listen((List<PurchaseDetails> purchaseDetailsList) async {
    //           for (var purchaseDetails in purchaseDetailsList) {
    //             print('hiii67');
    //             if (purchaseDetails.productID == event.productId) {
    //               switch (purchaseDetails.status) {
    //                 case PurchaseStatus.purchased:
    //                   // Complete the purchase
    //                   await _iap.completePurchase(purchaseDetails);

    //                   emit(InAppPurchaseSuccess());
    //                   break;

    //                 case PurchaseStatus.error:
    //                   emit(InAppPurchaseFailure(
    //                       error: purchaseDetails.error?.message ??
    //                           "Purchase error"));
    //                   break;

    //                 case PurchaseStatus.pending:
    //                   emit(InAppPurchaseFailure(error: 'Pending'));
    //                   break;

    //                 default:
    //                   emit(InAppPurchaseFailure(
    //                       error:
    //                           "Unknown purchase status: ${purchaseDetails.status}"));
    //                   break;
    //               }
    //             }
    //           }
    //         });
    //         final purchaseParam = PurchaseParam(productDetails: products.first);

    //         // Initiate the purchase
    //         final success =
    //             await _iap.buyConsumable(purchaseParam: purchaseParam);

    //         if (!success) {
    //           emit(InAppPurchaseFailure(error: "Purchase failed."));
    //           return;
    //         }
    //       } catch (e) {
    //         print(e);
    //         emit(InAppPurchaseFailure(error: e.toString()));
    //       }
    //     } else {
    //       emit(InAppPurchaseFailure(error: "Products not found"));
    //     }
    //   }
    // });

    on<MakePaymentButtonClickedEvent>((event, emit) async {
      emit(BookingLoadingState());

      final userDetail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(userDetail);
      var input = BookingRequestModel(
          userId: user.userId,
          classId: event.classId,
          durationId: event.durationId,
          timeslotId: event.timeslotId,
          startDate: event.startDate,
          apiToken: user.apiToken,
          isIos: event.isIos);

      print(input.toJson());

      final apiRequest = await PurchaseApi.confirmBooking(input: input);

      print(apiRequest.data);

      if (apiRequest.success) {
        if (apiRequest.data['status'].toString() == '1') {
          emit(BookingSuccessState(
            data: BookingSuccessModel(
                bookingSummaryId: int.parse(
                  apiRequest.data['bookingsummary_id']?.toString() ?? '0',
                ),
                bookingRefNo:
                    apiRequest.data['booking_unique_id']?.toString() ?? '0',
                isFreeClass: false),
          ));
        } else if (apiRequest.data['status'].toString() == '2') {
          emit(BookingSuccessState(
            data: BookingSuccessModel(
                bookingSummaryId: int.parse(
                    apiRequest.data['bookingsummary_id']?.toString() ?? '0'),
                bookingRefNo:
                    apiRequest.data['booking_unique_id']?.toString() ?? '0',
                isFreeClass: true),
          ));
        } else {
          emit(BookingFailureState(
              error: BookingFailureModel(
                  failureMessage: apiRequest.data['message'] ?? '')));
        }
      } else {
        emit(BookingFailureState(
            error: BookingFailureModel(
                failureMessage: apiRequest.errorMessage ?? '')));
      }
    });

    //
    on<UpdatePaymentStatusEvent>((event, emit) async {
      emit(PaymentLoadingState());

      final userDetail = await HiveServices.read('user_detail');

      final user = ProfileDetailModel.fromJson(userDetail);
      var input = PaymentRequestModel(
          userId: user.userId,
          bookingSummaryId: event.bookingId,
          paymentId: event.paymentId,
          paymentStatus: event.paymentStatus,
          apiToken: user.apiToken);

      final apiRequest = await PurchaseApi.updatePaymentStatus(input: input);

      if (apiRequest.success) {
        if (apiRequest.data['status'].toString() == '1') {
          emit(PaymentSuccessState());
        } else if (apiRequest.data['status'].toString() == '2') {
          emit(PaymentExpiredState(
              error: apiRequest.data['message'] ?? 'Session Expired'));
        } else {
          emit(PaymentFailedState());
        }
      } else {
        emit(PaymentFailedState());
      }
    });

    on<PaymentFailedEvent>((event, emit) {
      emit(PaymentFailedState());
    });
  }
}
