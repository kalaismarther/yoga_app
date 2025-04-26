import 'dart:convert';
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:http/http.dart' as http;

class TestimonialApi {
  static Future<ApiResponse> getTestimonials() async {
    try {
      final request = await http.get(Uri.parse(ApiUrl.getTestimonials),
          headers: {'Content-type': 'application/json'});

      if (request.statusCode == 200) {
        var result = json.decode(request.body);
        return ApiResponse(success: true, data: result);
      } else {
        return const ApiResponse(
            success: false, data: {}, errorMessage: 'Something went wrong');
      }
    } catch (e) {
      return ApiResponse(success: false, data: {}, errorMessage: e.toString());
    }
  }
}
