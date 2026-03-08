import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';
import 'settings_dao.dart';

class VouchersDao {
  final AppDatabase db;
  final SettingsDao settingsDao;

  VouchersDao(this.db, this.settingsDao);

  // ─── جلب قائمة السندات مع الفلاتر ────────────────────────
  Stream<List<Voucher>> watchAllVouchers(String typeFilter, String sortFilter) {
    final query = db.select(db.vouchers);

    if (typeFilter != 'ALL') {
      query.where((t) => t.type.equals(typeFilter));
    }

    if (sortFilter == 'NEWEST') {
      query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]);
    } else if (sortFilter == 'OLDEST') {
      query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]);
    } else if (sortFilter == 'HIGH_AMOUNT') {
      query.orderBy([(t) => OrderingTerm(expression: t.amount, mode: OrderingMode.desc)]);
    } else if (sortFilter == 'LOW_AMOUNT') {
      query.orderBy([(t) => OrderingTerm(expression: t.amount, mode: OrderingMode.asc)]);
    }

    return query.watch();
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
  Future<int> saveVoucher(VouchersCompanion voucher) async {
    return await db.transaction(() async {
      // إذا كان السند جديداً، نولد له رقماً تسلسلياً
      if (!voucher.id.present) {
        final nextNum = await _getNextVoucherNumber(voucher.type.value);
        final newVoucher = voucher.copyWith(
          voucherNumber: Value(nextNum),
        );
        // نُرجع الـ ID الجديد
        return await db.into(db.vouchers).insert(newVoucher);
      } else {
        await (db.update(db.vouchers)
          ..where((t) => t.id.equals(voucher.id.value)))
            .write(voucher);
        // نُرجع الـ ID الحالي
        return voucher.id.value;
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