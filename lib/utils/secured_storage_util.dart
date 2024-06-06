import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SecureStorageUtil {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId'; // New constant for user ID key

  static Future<void> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox('secureBox');
    _secureBox = box;
  }

  static Box? _secureBox;

  // Methods for token
  static Future<String?> getToken() async {
    return await _secureBox?.get(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    await _secureBox?.put(_tokenKey, token);
  }

  static Future<void> deleteToken() async {
    try {
      if (_secureBox != null) {
        await _secureBox?.delete(_tokenKey);
        debugPrint('Token deleted successfully');
      } else {
        debugPrint('Secure box not initialized');
      }
    } catch (e) {
      debugPrint('Error deleting token: $e');
    }
  }

  // Methods for user ID
  static Future<int?> getUserId() async {
    return await _secureBox?.get(_userIdKey);
  }

  static Future<int?> setUserId(int userId) async {
    await _secureBox?.put(_userIdKey, userId);
    return null;
  }

  static Future<void> deleteUserId() async {
    try {
      if (_secureBox != null) {
        await _secureBox?.delete(_userIdKey);
        debugPrint('User ID deleted successfully');
      } else {
        debugPrint('Secure box not initialized');
      }
    } catch (e) {
      debugPrint('Error deleting user ID: $e');
    }
  }
}
