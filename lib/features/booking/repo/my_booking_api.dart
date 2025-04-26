import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/booking/models/my_booking_request_model.dart';
import 'package:yoga_app/features/booking/models/view_detail_request_model.dart';

class MyBookingApi {
  static Future<ApiResponse> getMyBookingsList(
      {required MyBookingRequestModel input}) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.myBookingsList),
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

  static Future<ApiResponse> getDetail(
      {required ViewDetailRequestModel input}) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.myBookingDetail),
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
