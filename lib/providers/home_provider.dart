// مسار الملف: lib/providers/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/dashboard_dao.dart';
import '../screens/home/dashboard_stats.dart';

// 🔴 1. مزود جديد لحفظ التاريخ المختار (يبدأ دائماً بتاريخ اليوم عند فتح التطبيق)
final dashboardDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// 🔴 2. تحديث المزود الحي ليراقب التاريخ الجديد ويرسله للـ DAO
final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>((ref) {
  final dao = ref.watch(dashboardDaoProvider);
  final selectedDate = ref.watch(dashboardDateProvider); // نراقب التغيير هنا

  return dao.watchDashboardStats(selectedDate); // نمرر التاريخ
});