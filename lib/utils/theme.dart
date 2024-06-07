// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:wedevs_assignment/constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.whiteColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1.5,
            color: AppColors.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: .9,
            color: AppColors.greyColor,
          ),
        ),
      ),
    );
  }
}
