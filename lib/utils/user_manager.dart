// مسار الملف: lib/utils/user_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const String _usersKey = 'app_users_list';
  static const String _currentUserKey = 'current_active_user_id';

  // جلب قائمة المستخدمين (Map<id, name>)
  static Future<Map<String, String>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) {
      // المستخدم الافتراضي عند أول تشغيل للتطبيق
      final defaultUsers = {'default_user': 'المستخدم الافتراضي'};
      await prefs.setString(_usersKey, jsonEncode(defaultUsers));
      await prefs.setString(_currentUserKey, 'default_user');
      return defaultUsers;
    }
    return Map<String, String>.from(jsonDecode(usersJson));
  }

  // جلب ID المستخدم النشط حالياً
  static Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? currentId = prefs.getString(_currentUserKey);
    if (currentId == null) {
      await getUsers(); // لتهيئة الافتراضي
      currentId = prefs.getString(_currentUserKey);
    }
    return currentId ?? 'default_user';
  }

  // تغيير المستخدم النشط
  static Future<void> setCurrentUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, id);
  }

  // إضافة مستخدم جديد
  static Future<String> addUser(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    users[newId] = name;
    await prefs.setString(_usersKey, jsonEncode(users));
    return newId;
  }

  // حذف مستخدم
  static Future<void> deleteUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    users.remove(id);
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  // تعديل اسم مستخدم
  static Future<void> updateUserName(String id, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();
    if (users.containsKey(id)) {
      users[id] = newName;
      await prefs.setString(_usersKey, jsonEncode(users));
    }
  }
}