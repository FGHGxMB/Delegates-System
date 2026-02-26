import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/daos/settings_dao.dart';
import '../config/password_config.dart';

class PasswordService {
  final SettingsDao settingsDao;

  PasswordService(this.settingsDao);

  // حساب الرقم الأساسي بناءً على تاريخ اليوم
  int _computeBase(DateTime date) {
    final d = date.day;
    final m = date.month;
    final y = date.year % 100; // نأخذ آخر رقمين من السنة (مثلاً 26 من 2026)
    return ((d * m * 7) + (y * 3) + PasswordConfig.seedOffset) % 9000 + 1000;
  }

  // جلب كلمة السر الصحيحة للدورة الحالية
  Future<String> getCurrentPassword() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    final lastDate = await settingsDao.getValue('password_last_date') ?? '';
    int cycleIndex = int.tryParse(await settingsDao.getValue('password_cycle_index') ?? '0') ?? 0;

    // تصفير الدورة إذا بدأ يوم جديد
    if (lastDate != todayStr) {
      cycleIndex = 0;
      await settingsDao.setValue('password_cycle_index', '0');
      await settingsDao.setValue('password_last_date', todayStr);
    }

    final base = _computeBase(today);
    final password = (base + cycleIndex * PasswordConfig.rotationPrime) % 10000;

    // إرجاعها كنص من 4 أرقام (لو كانت 3 أرقام يضيف صفر على اليسار)
    return password.toString().padLeft(4, '0');
  }

  // التحقق من الإدخال (النظام الثلاثي)
  Future<bool> verifyPassword(String input) async {
    // 1. التحقق من كلمة سر الطوارئ الثابتة
    if (input == PasswordConfig.masterPassword) {
      return true; // الدخول فوراً دون تغيير الدورة
    }

    // 2. التحقق من كلمة السر المخصصة للمندوب (إن وُجدت)
    final customPassword = await settingsDao.getValue('custom_delegate_password');
    if (customPassword != null && customPassword.isNotEmpty && input == customPassword) {
      return true; // الدخول فوراً
    }

    // 3. التحقق من كلمة السر المتغيرة (الرياضية)
    final correctRolling = await getCurrentPassword();
    print('🔑 [للتطوير] كلمة السر المتغيرة الحالية: $correctRolling');

    if (input == correctRolling) {
      await _advanceCycle(); // التقدم للدورة التالية فقط إذا استخدم الكلمة المتغيرة
      return true;
    }

    return false; // جميع المحاولات خاطئة
  }

  // التقدم لدورة جديدة
  Future<void> _advanceCycle() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    int cycleIndex = int.tryParse(await settingsDao.getValue('password_cycle_index') ?? '0') ?? 0;

    cycleIndex = (cycleIndex + 1) % PasswordConfig.dailyCycles;

    await settingsDao.setValue('password_cycle_index', cycleIndex.toString());
    await settingsDao.setValue('password_last_date', todayStr);
  }
}

// مزود (Provider) للخدمة
final passwordServiceProvider = Provider<PasswordService>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return PasswordService(dao);
});