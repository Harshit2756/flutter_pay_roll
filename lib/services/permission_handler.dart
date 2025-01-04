import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  /// Check and request camera permission
  Future<bool> handleCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }

    return cameraStatus.isGranted;
  }

  /// Check and request location permission
  Future<bool> handleLocationPermission() async {
    PermissionStatus locationStatus = await Permission.location.status;

    if (locationStatus.isDenied) {
      locationStatus = await Permission.location.request();
    }

    return locationStatus.isGranted;
  }

  /// Check and request both camera and location permissions
  Future<Map<Permission, bool>> handleRequiredPermissions() async {
    Map<Permission, bool> permissions = {};

    permissions[Permission.camera] = await handleCameraPermission();
    permissions[Permission.location] = await handleLocationPermission();

    return permissions;
  }

  /// Check if permissions are permanently denied
  Future<bool> isPermanentlyDenied(Permission permission) async {
    return await permission.isPermanentlyDenied;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}
