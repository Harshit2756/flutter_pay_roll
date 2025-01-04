import '../jsons/dummy_json.dart';
import '../shared/storage_helper.dart';

class AuthService {
  // Sign in with email and password
  Future<Map<String, dynamic>?> login(String userName, String password) async {
    try {
      // Using mock data instead of HTTP call
      final Map<String, dynamic> response = loginResult;

      // Treating this as a successful response
      final Map<String, dynamic> data = response;
      final int? empId = data['empId'];

      if (data.isNotEmpty) {
        StorageHelper.storeUserData(data);
      }


      if (empId != null) {
        await StorageHelper.storeEmpId(empId.toString());
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> logout() async {
    try {

      await StorageHelper.deleteUserData();
    } catch (e) {
      rethrow;
    }
  }
}
