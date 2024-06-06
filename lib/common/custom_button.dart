import 'package:flutter/material.dart';

import 'package:wedevs_assignment/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color? color;
  final double? height;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color = AppColors.primaryColor,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color?.withOpacity(.2) ?? AppColors.primaryColor,
              blurRadius: 48,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
