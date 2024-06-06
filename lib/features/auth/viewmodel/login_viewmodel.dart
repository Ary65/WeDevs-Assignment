import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:wedevs_assignment/features/auth/services/auth_services.dart';
import 'package:wedevs_assignment/utils/loader.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';
import 'package:wedevs_assignment/utils/snackbar_util.dart';

final loginViewModelProvider =
    ChangeNotifierProvider((ref) => LoginViewModel());

class LoginViewModel extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _errorString = "";
  bool _obscurePass = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;
  String get errorString => _errorString;
  bool get obscurePass => _obscurePass;

  void toggleObscurePass() {
    _obscurePass = !_obscurePass;
    notifyListeners();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  void login(WidgetRef ref, BuildContext context) async {
    LoaderClass.showLoadingDialog(context, 'Loading');

    final token = await _authServices.loginUser(
      username: _usernameController.text,
      password: _passwordController.text,
      context: context,
      ref: ref,
    );

    if (token != null) {
      SecureStorageUtil.setToken(token);
      if (context.mounted) {
        context.pop(true);
        GoRouter.of(context).pushReplacement('/');
        SnackBarUtil.showSuccessSnackBar(context, 'Login successful!');
      }
    } else {
      if (context.mounted) {
        SnackBarUtil.showErrorSnackBar(context, 'Login failed!');
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
