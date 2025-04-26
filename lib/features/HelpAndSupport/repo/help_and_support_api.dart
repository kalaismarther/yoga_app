import 'dart:convert';
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/HelpAndSupport/models/help_request_model.dart';
import 'package:http/http.dart' as http;

class HelpAndSupportApi {
  static Future<ApiResponse> sendHelpRequest(HelpRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.helpandsupport),
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
