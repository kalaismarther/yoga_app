import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/purchase/models/booking_request_model.dart';
import 'package:yoga_app/features/purchase/models/payment_request_model.dart';
import 'package:yoga_app/features/purchase/models/yoga_detail_request_model.dart';

class PurchaseApi {
  static Future<ApiResponse> getYogaDetail(
      {required YogaDetailRequestModel input, required String token}) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.yogaDetail),
          headers: {'Content-type': 'application/json', 'Authorization': token},
          body: json.encode(input.toJson()));

      print(ApiUrl.yogaDetail);
      print(input.toJson());
      print(request.body);
      print(request.statusCode);

      if (request.statusCode == 200) {
        var response = json.decode(request.body);
        return ApiResponse(success: true, data: response);
      } else {
        return const ApiResponse(
            success: false,
            data: {},
            errorMessage: 'Something went wrong. Please try again later');
      }
    } catch (e) {
      return ApiResponse(success: false, data: {}, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> confirmBooking(
      {required BookingRequestModel input}) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.confirmBooking),
          headers: {
            'Content-type': 'application/json',
            'Authorization': input.apiToken
          },
          body: json.encode(input.toJson()));

      //
      if (request.statusCode == 200) {
        var response = json.decode(request.body);
        print(response);
        return ApiResponse(success: true, data: response);
      } else {
        return const ApiResponse(
            success: false,
            data: {},
            errorMessage: 'Something went wrong. Please try again later');
      }
    } catch (e) {
      return ApiResponse(success: false, data: {}, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> updatePaymentStatus(
      {required PaymentRequestModel input}) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.updatePayment),
          headers: {
            'Content-type': 'application/json',
            'Authorization': input.apiToken
          },
          body: json.encode(input.toJson()));

      if (request.statusCode == 200) {
        var response = json.decode(request.body);
        return ApiResponse(success: true, data: response);
      } else {
        return const ApiResponse(
            success: false,
            data: {},
            errorMessage: 'Something went wrong. Please try again later');
      }
    } catch (e) {
      return ApiResponse(success: false, data: {}, errorMessage: e.toString());
    }
  }
}
