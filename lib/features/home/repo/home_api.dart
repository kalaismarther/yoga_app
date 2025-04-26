import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/home/models/home_request_model.dart';

class HomeApi {
  static Future<ApiResponse> getYogaCourses(HomeRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.yogaCoursesUrl),
          headers: {
            'Content-type': 'application/json',
            'Authorization': input.apiToken
          },
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
}
