import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:wedevs_assignment/constants/colors.dart';

class CustomTextField extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obSecure;
  final Iterable<String>? autofillHints;
  final bool? isReadOnly;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    required this.obSecure,
    this.autofillHints,
    this.isReadOnly,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: autofillHints,
      controller: controller,
      validator: validator,
      textAlign: TextAlign.left,
      obscureText: obSecure,
      readOnly: isReadOnly ?? false,
      onTap: onTap,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.all(13),

        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
        suffixIcon: suffixIcon,
        // prefixIcon: prefixIcon,
        prefixIcon: prefixIcon == null
            ? const SizedBox()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (prefixIcon != null) prefixIcon!,
                  if (prefixIcon != null)
                    Container(
                      width: 1, // Width of the vertical divider
                      height: 24, // Height of the divider
                      color: Colors.grey,
                      margin: const EdgeInsets.only(right: 8.0),
                    )
                ],
              ),
        prefixIconColor: AppColors.primaryColor,
        suffixIconColor: AppColors.blackColor,
        labelText: labelText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        // enabledBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        //   borderSide: BorderSide(
        //     width: .1,
        //     color: AppColors.gray,
        //   ),
        // ),
        // focusedBorder: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        //   borderSide: BorderSide(
        //     width: 1.5,
        //     color: AppColors.primaryColor,
        //   ),
        // ),
      ),
    );
  }
}
