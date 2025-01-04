import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_roll/services/get_time_service.dart';
import 'package:pay_roll/shared/loadings.dart';
import 'package:pay_roll/shared/storage_helper.dart';
import 'package:pay_roll/ui/auth/login.dart';
import 'package:pay_roll/ui/bottom_nav_bar.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginAndExpiry(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }

          final bool isValidLogin = snapshot.data ?? false;

          if (isValidLogin) {
            return const BottomNavBar();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _checkPermissions();
    GetTimeService();
  }

  Future<bool> _checkLoginAndExpiry() async {
    bool isLoggedIn = await StorageHelper.isUserLoggedIn();
    if (!isLoggedIn) return false;
    return true;
  }

  // Future<void> _checkPermissions() async {
  //   Map<Permission, bool> permissions =
  //       await _permissionService.handleRequiredPermissions();

  //   if (!permissions[Permission.camera]!) {
  //     // If permissions are permanently denied, open app settings
  //     if (await _permissionService.isPermanentlyDenied(Permission.camera)) {
  //       await _permissionService.openAppSettings();
  //     }
  //   }
  // }
}
