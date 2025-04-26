import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoga_app/Api/api_response.dart';
import 'package:yoga_app/Api/api_url.dart';
import 'package:yoga_app/features/profile/models/delete_account_request_model.dart';
import 'package:yoga_app/features/profile/models/edit_profile_request_model.dart';
import 'package:yoga_app/features/profile/models/profile_image_request_model.dart';
import 'package:yoga_app/features/profile/models/update_profile_request_model.dart';

class ProfileApi {
  static Future<ApiResponse> updateUserProfile(
      UpdateProfileRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.updateProfile),
          headers: {
            'Content-type': 'application/json',
            'Authorization': input.apiToken
          },
          body: json.encode(input.toJson()));

      print(input.toJson());
      print(input.apiToken);
      print(request.statusCode);
      print(json.decode(request.body));

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

  static Future<ApiResponse> editUserProfile(
      EditProfileRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.editProfile),
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

  static Future<ApiResponse> showDeleteIcon() async {
    try {
      final request = await http.get(
        Uri.parse(ApiUrl.deleteIcon),
        headers: {
          'Content-type': 'application/json',
        },
      );

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

  static Future<ApiResponse> updateUserProfileImage(
      ProfileImageRequestModel input) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(ApiUrl.updateProfileImage));

      request.headers['Authorization'] = input.apiToken;

      request.fields['user_id'] = input.userId.toString();

      request.files.add(
          await http.MultipartFile.fromPath('profile_image', input.imagePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var result = json.decode(responseBody);

        return ApiResponse(success: true, data: result);
      } else {
        return const ApiResponse(
            success: false, data: {}, errorMessage: 'Something went wrong');
      }
    } catch (e) {
      return ApiResponse(success: false, data: {}, errorMessage: e.toString());
    }
  }

  static Future<ApiResponse> deleteUserAccount(
      DeleteAccountRequestModel input) async {
    try {
      final request = await http.post(Uri.parse(ApiUrl.deleteAccountUrl),
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
