import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/routers.dart';
import 'package:wedevs_assignment/features/constants/colors.dart';
import 'package:wedevs_assignment/utils/secured_storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageUtil.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
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
      ),
      routerConfig: router,
    );
  }
}
