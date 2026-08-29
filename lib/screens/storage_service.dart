import 'package:hive/hive.dart';

class StorageService {
  static const String userBox = "users";

  /// Internal helper to reuse the open box without reopening it repeatedly
  static Future<Box> _getBox() async {
    if (Hive.isBoxOpen(userBox)) {
      return Hive.box(userBox);
    }
    return await Hive.openBox(userBox);
  }

  /// Save user data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final box = await _getBox();
    await box.put("current_user", user);
  }

  /// Retrieve current user safely cast as Map<String, dynamic>
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final box = await _getBox();
    final data = box.get("current_user");

    if (data != null) {
      return Map<String, dynamic>.from(data as Map);
    }
    return null;
  }

  /// Clear user data on logout
  static Future<void> clearUser() async {
    final box = await _getBox();
    await box.delete("current_user");
  }

  /// Helper to check if a user session exists
  static Future<bool> isLoggedIn() async {
    final box = await _getBox();
    return box.containsKey("current_user");
  }
}