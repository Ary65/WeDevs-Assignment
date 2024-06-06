import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

final isLoggedInProvider = StreamProvider.autoDispose<bool>((ref) async* {
  final token = await SecureStorageUtil.getToken();
  debugPrint(token);
  yield token != null;
});
