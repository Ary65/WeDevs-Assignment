import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  
  Future<void> logOut(WidgetRef ref) async {
    await SecureStorageUtil.deleteToken();

    ref.invalidate(isLoggedInProvider);
  }
}
