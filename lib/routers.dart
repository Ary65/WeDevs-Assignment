import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:wedevs_assignment/features/auth/screens/login_screen.dart';
import 'package:wedevs_assignment/features/auth/screens/sign_up_screen.dart';
import 'package:wedevs_assignment/layouts/layout_screen.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LayoutScreen();
      },
      redirect: (context, state) async {
        final token = await SecureStorageUtil.getToken();
        debugPrint(token);
        if (token?.isNotEmpty ?? false) {
          return '/';
        } else {
          return '/login';
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen();
          },
        ),
      ],
    )
  ],
);
