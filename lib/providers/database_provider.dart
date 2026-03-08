// مسار الملف: lib/providers/database_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

// 1. مزود يحتفظ بـ ID المستخدم الحالي (يبدأ بالافتراضي)
final currentUserIdProvider = StateProvider<String>((ref) => 'default_user');

// 2. مزود قاعدة البيانات (يستمع للمستخدم الحالي ويفتح ملفه الخاص)
final databaseProvider = Provider<AppDatabase>((ref) {
  final userId = ref.watch(currentUserIdProvider);

  // تمرير اسم المستخدم لقاعدة البيانات لفتح الملف الصحيح
  final db = AppDatabase(userId);

  // إغلاق الاتصال عند تبديل المستخدم لتجنب تسريب الذاكرة
  ref.onDispose(() => db.close());

  return db;
});