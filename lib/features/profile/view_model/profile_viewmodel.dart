import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wedevs_assignment/constants/colors.dart';
import 'package:wedevs_assignment/features/profile/services/profile_services.dart';
import 'package:wedevs_assignment/models/user_model.dart';
import 'package:wedevs_assignment/providers/logged_in_provider.dart';
import 'package:wedevs_assignment/utils/loader.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';
import 'package:wedevs_assignment/utils/toast.dart';

final profileViewModelProvider =
    ChangeNotifierProvider<ProfileViewModel>((ref) {
  return ProfileViewModel(ref);
});

class ProfileViewModel extends ChangeNotifier {
  final ProfileServices _profileServices = ProfileServices();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  ProfileViewModel(Ref ref) {
    _loadUserProfile(ref);
  }

  Future<void> _loadUserProfile(Ref ref) async {
    final token = await SecureStorageUtil.getToken();
    debugPrint('Token retrieved from Hive: $token');
    if (token != null) {
      final userDetails = await _profileServices.fetchUserDetails(token);
      if (userDetails != null) {
        _user = userDetails;
        firstNameController.text = userDetails.firstName;
        lastNameController.text = userDetails.lastName;
        SecureStorageUtil.setUserId(userDetails.id);
        ref.invalidate(isLoggedInProvider);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(WidgetRef ref, BuildContext context) async {
    LoaderClass.showLoadingDialog(context, 'Updating');
    final token = await SecureStorageUtil.getToken();
    final success = await _profileServices.updateUserProfile(
      token!,
      firstNameController.text,
      lastNameController.text,
    );
    if (success) {
      if (context.mounted) {
        context.pop(true);
      }
      showToast(
        'Profile updated successfully!',
        AppColors.snackBarColor,
      );
    } else {
      showToast(
        'Profile update failed!',
        AppColors.dangerColor,
      );
    }
    notifyListeners();
  }
}
