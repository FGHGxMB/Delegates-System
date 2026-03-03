// مسار الملف المقترح: lib/screens/home/providers/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/dashboard_dao.dart';
import '../screens/home/dashboard_stats.dart';

// نستخدم StreamProvider لمراقبة الإحصائيات بشكل حي ومباشر
final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>((ref) {
  final dao = ref.watch(dashboardDaoProvider);
  return dao.watchTodayDashboardStats();
});