import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

// مزود قاعدة البيانات الرئيسي
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});