import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedevs_assignment/features/auth/services/auth_services.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider).asData?.value ?? false;
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: isLoggedIn
                ? () {
                    AuthServices().logOut(ref);
                    context.push('/login');
                  }
                : () {
                    context.push('/login');
                  },
            child: Chip(
              label: Text(isLoggedIn ? 'Log Out' : 'Log In'),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
