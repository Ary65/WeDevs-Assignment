import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/models/user_model.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

class AuthServices {
  final String baseUrl = 'http://apptest.dokandemo.com/wp-json/wp/v2';
  final Dio dio = Dio(BaseOptions(followRedirects: true, maxRedirects: 5));
  Future<void> saveToken(String token) async {
    await SecureStorageUtil.setToken(token);
  }

  Future<String?> loginUser({
    required String username,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final response = await dio.post(
        'https://apptest.dokandemo.com/wp-json/jwt-auth/v1/token',
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'username': username,
          'password': password,
        },
      );
      debugPrint('loginUser response: $response');
      if (response.statusCode == 200) {
        return response.data['token'];
      }
      return null;
    } catch (e) {
      debugPrint('loginUser error: $e');
      return null;
    }
  }

  Future<bool> registerUser(
      String username, String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/register',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      debugPrint('registerUser response: $response');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('registerUser error: $e');
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
                headers: {'Content-Type': 'application/json'},
              ),
              data: jsonEncode({
                'username': username,
                'email': email,
                'password': password,
              }),
            );
            debugPrint('redirectResponse: $redirectResponse');
            return redirectResponse.statusCode == 200;
          } catch (e) {
            debugPrint('Redirect registerUser error: $e');
            return false;
          }
        }
      }
      return false;
    }
  }

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

  Future<void> logOut(WidgetRef ref) async {
    await SecureStorageUtil.deleteToken();

    ref.invalidate(isLoggedInProvider);
  }
}
