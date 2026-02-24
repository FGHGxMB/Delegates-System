import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // تم النقل للأعلى
import '../database.dart';
import '../tables.dart';
import '../../providers/database_provider.dart'; // تم النقل للأعلى

class SettingsDao {
  final AppDatabase db;

  SettingsDao(this.db);

  // جلب قيمة من الإعدادات
  Future<String?> getValue(String key) async {
    final query = db.select(db.settings)..where((tbl) => tbl.key.equals(key));
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  // حفظ أو تحديث قيمة في الإعدادات
  Future<void> setValue(String key, String value) async {
    await db.into(db.settings).insertOnConflictUpdate(
      SettingsCompanion(
        key: Value(key),
        value: Value(value),
      ),
    );
  }

  // تهيئة الإعدادات الافتراضية إذا لم تكن موجودة
  Future<void> initializeDefaultSettings(Map<String, String> defaults) async {
    for (var entry in defaults.entries) {
      final existing = await getValue(entry.key);
      if (existing == null) {
        await setValue(entry.key, entry.value);
      }
    }
  }
}

// مزود (Provider) خاص بالـ SettingsDao
final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsDao(db);
});