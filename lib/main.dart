import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  // التأكد من تهيئة الفلاتر قبل تشغيل التطبيق (مهم جداً لقاعدة البيانات)
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // تغليف التطبيق بـ ProviderScope لتفعيل Riverpod
    const ProviderScope(
      child: MainApp(),
    ),
  );
}