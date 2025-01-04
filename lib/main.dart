import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:pay_roll/ui/attendance/attendance.dart';
import 'package:pay_roll/ui/auth/auth_wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      backgroundColor: Colors.white,
      tools: const [
        DeviceSection(
          frameVisibility: false,
          orientation: false,
          virtualKeyboard: true,
        ),
        SystemSection(
          locale: false,
          theme: false,
        ),
        DevicePreviewScreenshot(),
        SettingsSection(),
      ],
      devices: [
        Devices.android.samsungGalaxyA50,
        Devices.android.samsungGalaxyNote20,
        Devices.android.samsungGalaxyS20,
        Devices.android.samsungGalaxyNote20Ultra,
        Devices.android.onePlus8Pro,
        Devices.android.sonyXperia1II,
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone12,
        Devices.ios.iPhone12Mini,
        Devices.ios.iPhone12ProMax,
        Devices.ios.iPhone13,
        Devices.ios.iPhone13ProMax,
        Devices.ios.iPhone13Mini,
        Devices.ios.iPhoneSE,
      ],
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TimerProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          home: const AuthWrapper(),
        ),
      ),
    ),
  );
}
