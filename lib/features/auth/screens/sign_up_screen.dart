import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedevs_assignment/common/custom_button.dart';
import 'package:wedevs_assignment/common/custom_textfield.dart';
import 'package:wedevs_assignment/features/auth/screens/login_screen.dart';

import 'package:wedevs_assignment/features/auth/viewmodel/sign_up_viewmodel.dart';
import 'package:wedevs_assignment/constants/app_defaults.dart';
import 'package:wedevs_assignment/constants/colors.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.sizeOf(context).height;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Consumer(
              builder: (context, ref, child) {
                final viewModel = ref.watch(signUpViewModelProvider);

                return Form(
                  key: viewModel.registerKey,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.125),
                        SvgPicture.asset('assets/app/Dokan Logo.svg'),
                        SizedBox(height: height * 0.1),
                        Text(
                          "Sign up",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        CustomTextField(
                          controller: viewModel.usernameController,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username
                          ],
                          labelText: 'Name',
                          obSecure: false,
                          validator: viewModel.validateUsername,
                          prefixIcon: const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: viewModel.emailController,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username
                          ],
                          labelText: 'Email',
                          obSecure: false,
                          validator: viewModel.validateEmail,
                          prefixIcon: const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                          controller: viewModel.passwordController,
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                          labelText: 'Password',
                          prefixIcon: const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.lock,
                            ),
                          ),
                          obSecure: viewModel.obscurePass,
                          validator: viewModel.validatePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              viewModel.toggleObscurePass();
                            },
                            icon: Icon(
                              viewModel.obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: viewModel.passwordController.text.isEmpty
                                  ? AppColors.greyColor
                                  : AppColors.blackColor,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        CustomButton(
                          onTap: () {
                            if (viewModel.registerKey.currentState!
                                .validate()) {
                              viewModel.signUp(ref, context);
                            }
                          },
                          text: 'Sign Up',
                          height: 60,
                        ),
                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              child: Text(
                "Login",
                style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
