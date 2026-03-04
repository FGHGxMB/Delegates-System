import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';
import 'settings_dao.dart';

class VouchersDao {
  final AppDatabase db;
  final SettingsDao settingsDao;

  VouchersDao(this.db, this.settingsDao);

  // ─── جلب قائمة السندات ──────────────────────────────────
  Stream<List<Voucher>> watchAllVouchers() {
    return (db.select(db.vouchers)
    // التعديل هنا: الترتيب حسب رقم المعرف ID (وهو يمثل الترتيب الزمني الفعلي)
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }

  // ─── جلب سند معين ─────────────────────────────────────
  Future<Voucher?> getVoucherById(int id) {
    return (db.select(db.vouchers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // ─── توليد رقم السند التسلسلي ──────────────────────────
  Future<int> _getNextVoucherNumber(String type) async {
    final settingKey = type == 'RECEIPT' ? 'last_receipt_voucher_number' : 'last_payment_voucher_number';
    final lastNumberStr = await settingsDao.getValue(settingKey) ?? '0';
    int nextNumber = (int.tryParse(lastNumberStr) ?? 0) + 1;

    // تحديث العداد في الإعدادات
    await settingsDao.setValue(settingKey, nextNumber.toString());
    return nextNumber;
  }

  // ─── حفظ السند (جديد أو تعديل) ─────────────────────────
  Future<void> saveVoucher(VouchersCompanion voucher) async {
    await db.transaction(() async {
      // إذا كان السند جديداً، نولد له رقماً تسلسلياً
      if (!voucher.id.present) {
        final nextNum = await _getNextVoucherNumber(voucher.type.value);
        final newVoucher = voucher.copyWith(
          voucherNumber: Value(nextNum),
        );
        await db.into(db.vouchers).insert(newVoucher);
      } else {
        // 🔴 الإصلاح السحري هنا: استخدام write للتحديث الجزئي بدلاً من replace
        await (db.update(db.vouchers)
          ..where((t) => t.id.equals(voucher.id.value)))
            .write(voucher);
      }
    });
  }

  // ─── حذف السند (مسموح للمسودات فقط) ─────────────────────
  Future<bool> deleteVoucher(int id) async {
    final voucher = await getVoucherById(id);
    if (voucher == null || voucher.status == 'SENT') return false;

    await (db.delete(db.vouchers)..where((t) => t.id.equals(id))).go();
    return true;
  }

  // ─── تحديث حالة السندات إلى مُرسلة ─────────────────────────
  Future<void> markUnsentAsSent() async {
    // نقوم بتحديث جميع السندات التي لم تُرسل بعد
    await (db.update(db.vouchers)..where((t) => t.status.isNotValue('SENT'))).write(
      const VouchersCompanion(status: Value('SENT')),
    );
  }
}

// ─── مزود Riverpod ──────────────────────────────────────
final vouchersDaoProvider = Provider<VouchersDao>((ref) {
  final db = ref.watch(databaseProvider);
  final settingsDao = ref.watch(settingsDaoProvider);
  return VouchersDao(db, settingsDao);
});