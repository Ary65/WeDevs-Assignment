import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wedevs_assignment/constants/base_url.dart';
import 'package:wedevs_assignment/models/user_model.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

class ProfileServices {
  final Dio dio = Dio(BaseOptions(followRedirects: true, maxRedirects: 5));
  Future<User?> fetchUserDetails(String token) async {
    try {
      final response = await dio.get(
        '$baseUrl/users/me?context=edit',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          followRedirects: false, // Disable automatic redirects
          validateStatus: (status) =>
              status! < 500, // Validate status for errors
        ),
      );
      debugPrint('fetchUserDetails response: $response');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else if (response.statusCode == 301 || response.statusCode == 302) {
        // Handle redirection manually if needed
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          // Perform another request to the redirected URL
          final redirectResponse = await dio.get(
            redirectUrl,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            ),
          );
          debugPrint('Redirected fetchUserDetails response: $redirectResponse');
          if (redirectResponse.statusCode == 200) {
            return User.fromJson(redirectResponse.data);
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('fetchUserDetails error: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(
      String token, String firstName, String lastName) async {
    try {
      final userId = await SecureStorageUtil.getUserId();
      debugPrint(userId.toString());
      final url = '$baseUrl/users/$userId';

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      debugPrint('updateUserProfile response: $response');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('updateUserProfile error: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 301 &&
            e.response?.headers['location'] != null) {
          final newUrl = e.response?.headers['location']![0];
          debugPrint('Redirecting to: $newUrl');
          // Attempt the request again with the new URL
          try {
            final redirectResponse = await dio.post(
              newUrl!,
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              ),
              data: jsonEncode({
                'first_name': firstName,
                'last_name': lastName,
              }),
            );
            debugPrint('redirectResponse: $redirectResponse');
            return redirectResponse.statusCode == 200;
          } catch (e) {
            debugPrint('Redirect updateUserProfile error: $e');
            return false;
          }
        }
      }
      return false;
    }
  }
}
