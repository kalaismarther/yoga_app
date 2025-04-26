import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/SwitchCourse/models/switch_course_request_model.dart';

class SwitchCourseApi {
  static Future<ApiResponse> searchYoga(SwitchCourseRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.switchOverClass),
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
