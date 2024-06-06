import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedevs_assignment/features/auth/services/auth_services.dart';
import 'package:wedevs_assignment/models/user_model.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _authService = AuthServices();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final token = await SecureStorageUtil.getToken();

    print('Token retrieved from Hive: $token');
    if (token != null) {
      final userDetails = await _authService.fetchUserDetails(token);
      if (userDetails != null) {
        setState(() {
          _user = userDetails;
          _firstNameController.text = userDetails.firstName;
          _lastNameController.text = userDetails.lastName;
        });

        SecureStorageUtil.setUserId(userDetails.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Failed to load user details. Please check your token.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No token found. Please log in again.')));
    }
  }

  void _updateProfile() async {
    final token = await SecureStorageUtil.getToken();

    final success = await _authService.updateUserProfile(
      token!,
      _firstNameController.text,
      _lastNameController.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile update failed!')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${_user!.id}'),
                  Text('Username: ${_user!.username}'),
                  Text('Name: ${_user!.name}'),
                  Text('Email: ${_user!.email}'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
      ),
    );
  }
}
