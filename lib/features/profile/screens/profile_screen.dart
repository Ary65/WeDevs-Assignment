import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedevs_assignment/common/custom_button.dart';
import 'package:wedevs_assignment/features/auth/services/auth_services.dart';
import 'package:wedevs_assignment/features/profile/view_model/profile_viewmodel.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileViewModel = ref.watch(profileViewModelProvider);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: profileViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          profileViewModel.user?.url ?? '',
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: TextEditingController(
                          text: profileViewModel.user!.username),
                      decoration: const InputDecoration(labelText: 'Username'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: TextEditingController(
                          text: profileViewModel.user!.email),
                      decoration: const InputDecoration(labelText: 'Email'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: profileViewModel.firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: profileViewModel.lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          onTap: () => profileViewModel.updateProfile(ref),
          text: 'Update Profile',
        ),
      ),
    );
  }
}
