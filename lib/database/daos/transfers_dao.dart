import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

// كلاس مساعد لجمع المناقلة مع موادها
class TransferWithLines {
  final Transfer transfer;
  final List<TransferLine> lines;
  TransferWithLines(this.transfer, this.lines);
}

class TransfersDao {
  final AppDatabase db;
  TransfersDao(this.db);

  // ─── جلب كل المناقلات ───
  Stream<List<Transfer>> watchAllTransfers() {
    return (db.select(db.transfers)
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }

  // ─── جلب مناقلة معينة مع موادها ───
  Future<TransferWithLines?> getTransferWithLines(int id) async {
    final transfer = await (db.select(db.transfers)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (transfer == null) return null;
    final lines = await (db.select(db.transferLines)..where((t) => t.transferId.equals(id))).get();
    return TransferWithLines(transfer, lines);
  }

  // ─── حفظ أو تعديل المناقلة ───
  Future<void> saveTransfer(TransfersCompanion transfer, List<TransferLinesCompanion> lines) async {
    await db.transaction(() async {
      int transferId;

      if (!transfer.id.present) {
        // 1. إذا كانت مناقلة جديدة كلياً
        transferId = await db.into(db.transfers).insert(transfer);
      } else {
        // 2. إذا كان تعديلاً على مسودة أو تخريجها
        transferId = transfer.id.value;

        // 🔴 الحل السحري: يجب إزالة حقل (id) من البيانات المحدثة كي لا تغضب قاعدة البيانات!
        final updateCompanion = transfer.copyWith(id: const Value.absent());

        await (db.update(db.transfers)..where((t) => t.id.equals(transferId))).write(updateCompanion);

        // مسح الأقلام القديمة استعداداً لإدخالها من جديد
        await (db.delete(db.transferLines)..where((t) => t.transferId.equals(transferId))).go();
      }

      // 3. إدخال الأقلام الجديدة المحدثة
      for (var line in lines) {
        await db.into(db.transferLines).insert(line.copyWith(transferId: Value(transferId)));
      }
    });
  }

  // ─── حذف المناقلة ───
  Future<bool> deleteTransfer(int id) async {
    final transfer = await (db.select(db.transfers)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (transfer == null || transfer.status == 'SENT') return false; // ممنوع حذف المُرسلة

    await db.transaction(() async {
      await (db.delete(db.transferLines)..where((t) => t.transferId.equals(id))).go();
      await (db.delete(db.transfers)..where((t) => t.id.equals(id))).go();
    });
    return true;
  }

  // ─── تحديث حالة المناقلات إلى مُرسلة ───
  Future<void> markUnsentAsSent() async {
    await (db.update(db.transfers)..where((t) => t.status.isNotValue('SENT'))).write(
      const TransfersCompanion(status: Value('SENT')),
    );
  }
}

// ─── مزود الـ Provider ───
final transfersDaoProvider = Provider<TransfersDao>((ref) {
  return TransfersDao(ref.watch(databaseProvider));
});