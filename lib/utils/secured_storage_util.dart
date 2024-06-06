import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SecureStorageUtil {
  static const String _tokenKey = 'token';

  static Future<void> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(
      'secureBox',
    );
    _secureBox = box;
  }

  static Box? _secureBox;

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
}
