import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/Auth/models/resend_request_model.dart';
import 'package:yoga_app/features/Auth/models/verification_request_model.dart';

class AuthApi {
  static Future<ApiResponse> userLogin(Map<String, dynamic> input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.login),
          headers: {'Content-type': 'application/json'},
          body: json.encode(input));

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

  static Future<ApiResponse> userVerification(
      VerificationRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.verifyOtp),
          headers: {'Content-type': 'application/json'},
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

  static Future<ApiResponse> verifyOtpEdit(
      VerificationRequestModel input, String token) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.verifyOtpEdit),
          headers: {'Content-type': 'application/json', 'Authorization': token},
          body: json.encode(input));

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

  static Future<ApiResponse> resendOtp(ResendRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.resendOtp),
          headers: {'Content-type': 'application/json'},
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
