import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/constants/base_url.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

class AuthServices {
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

  Future<void> logOut(WidgetRef ref) async {
    await SecureStorageUtil.deleteToken();

    ref.invalidate(isLoggedInProvider);
  }
}
