import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AuthUtils {
  static Future<String?> getToken() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString("token");
      print("Current Token: $token");
      return token;
    } catch (e) {
      print("Error getting token: $e");
      return null;
    }
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        print("No token found");
        Get.offAllNamed('/login');
        return {'Content-Type': 'application/json'};
      }
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      print("Error creating headers: $e");
      Get.offAllNamed('/login');
      return {'Content-Type': 'application/json'};
    }
  }

  static Future<bool> hasValidToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print("Error checking token validity: $e");
      return false;
    }
  }
} 