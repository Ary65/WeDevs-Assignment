import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:wedevs_assignment/features/auth/services/auth_services.dart';
import 'package:wedevs_assignment/utils/loader.dart';

import 'package:wedevs_assignment/utils/snackbar_util.dart';

final signUpViewModelProvider =
    ChangeNotifierProvider((ref) => SignUpViewModel());

class SignUpViewModel extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _errorString = "";
  bool _obscurePass = true;
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController;
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
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

  void signUp(WidgetRef ref, BuildContext context) async {
    LoaderClass.showLoadingDialog(context, 'Loading');

    final success = await _authServices.registerUser(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      if (context.mounted) {
        context.pop(true);
        GoRouter.of(context).pushReplacement('/login');
        SnackBarUtil.showSuccessSnackBar(context, 'Registration successful!');
      }
    } else {
      if (context.mounted) {
        SnackBarUtil.showErrorSnackBar(context, 'Registration failed!');
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
