import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const _storage = FlutterSecureStorage();
  static const String _empIdKey = 'emp_id';
  static const String _userNameKey = 'user_name';
  static const String _expiryTimeKey = 'expiry_time';
  static const String _trackingModeKey = 'tracking_mode';
  // Delete attendance status
  static Future<void> deleteAttendanceStatus(String date) async {
    await _storage.delete(key: date);
  }

  // Delete user data
  static Future<void> deleteUserData() async {
    await _storage.delete(key: _empIdKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _expiryTimeKey);
    // await _storage.delete(key: _attendanceStatusKey);
  }

  //get attendance status
  static Future<String?> getAttendanceStatus() async {
    debugPrint('getAttendanceStatus: ${await _storage.read(key: "lastEntry")}');

    final status = await _storage.read(key: "lastEntry");
    return status;
  }

  // Get user ID
  static Future<String?> getEmpId() async {
    // debugPrint('getEmpId: ${await _storage.read(key: _empIdKey)}');
    return await _storage.read(key: _empIdKey);
  }

  // Get expiry time
  static Future<String?> getExpiryTime() async {
    return await _storage.read(key: _expiryTimeKey);
  }

  // Get user name
  static Future<String?> getName() async {
    return await _storage.read(key: _userNameKey);
  }

  // Get tracking mode
  static Future<String?> getTrackingMode() async {
    return await _storage.read(key: _trackingModeKey);
  }

  // Get user data
  static Future<Map<String, dynamic>> getUserData() async {
    final userData = await _storage.read(key: 'user_data');
    debugPrint('getUserData: ${json.decode(userData ?? '{}')}');
    return json.decode(userData ?? '{}');
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final userId = await getEmpId();
    return userId != null;
  }

  // Store attendance status
  static Future<void> setAttendanceStatus(String status) async {
    debugPrint('setAttendanceStatus: "lastEntry" = $status');
    await _storage.write(key: "lastEntry", value: status);
  }

  // Store user ID
  static Future<void> storeEmpId(String userId) async {
    await _storage.write(key: _empIdKey, value: userId);
  }

  // Store expiry time
  static Future<void> storeExpiryTime(String expiryTime) async {
    await _storage.write(key: _expiryTimeKey, value: expiryTime);
  }

  // Store user name
  static Future<void> storeName(String name) async {
    await _storage.write(key: _userNameKey, value: name);
  }

  // Store tracking mode
  static Future<void> storeTrackingMode(String trackingMode) async {
    await _storage.write(key: _trackingModeKey, value: trackingMode);
  }

  // Store user data
  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    debugPrint('storeUserData: ${json.encode(userData)}');
    await _storage.write(key: 'user_data', value: json.encode(userData));
  }
}
