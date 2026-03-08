import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import '../utils/user_manager.dart';
import '../providers/database_provider.dart';

void main() async {
  // 1. التأكد من تهيئة الفلاتر قبل تشغيل أي كود
  WidgetsFlutterBinding.ensureInitialized();

  // 2. جلب آخر مستخدم نشط من ذاكرة الهاتف
  final currentUserId = await UserManager.getCurrentUserId();

  runApp(
    ProviderScope(
      overrides:[
        // 3. حقن اسم المستخدم في التطبيق قبل أن يبدأ
        currentUserIdProvider.overrideWith((ref) => currentUserId),
      ],
      child: const MainApp(),
    ),
  );
}