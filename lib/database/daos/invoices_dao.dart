import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';
import 'settings_dao.dart';

// كلاس مساعد يجمع الفاتورة مع أقلامها في حزمة واحدة
class InvoiceWithLines {
  final Invoice invoice;
  final List<InvoiceLine> lines;
  InvoiceWithLines(this.invoice, this.lines);
}

class InvoicesDao {
  final AppDatabase db;
  final SettingsDao settingsDao;

  InvoicesDao(this.db, this.settingsDao);

  // ─── 1. جلب الفواتير (للقوائم) ───
  Stream<List<Invoice>> watchInvoices(String type) {
    // type: 'SALE' أو 'RETURN'
    return (db.select(db.invoices)
      ..where((t) => t.type.equals(type))
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }

  // ─── 2. جلب فاتورة واحدة مع أقلامها (للتعديل والعرض) ───
  Future<InvoiceWithLines?> getInvoiceWithLines(int invoiceId) async {
    final invoice = await (db.select(db.invoices)..where((t) => t.id.equals(invoiceId))).getSingleOrNull();
    if (invoice == null) return null;

    final lines = await (db.select(db.invoiceLines)
      ..where((t) => t.invoiceId.equals(invoiceId))
      ..orderBy([(t) => OrderingTerm(expression: t.lineOrder)]))
        .get();

    return InvoiceWithLines(invoice, lines);
  }

  // ─── 3. حجز رقم فاتورة جديد ───
  Future<int> _getNextInvoiceNumber(String type) async {
    final settingKey = type == 'SALE' ? 'last_sale_invoice_number' : 'last_return_invoice_number';
    final lastNumStr = await settingsDao.getValue(settingKey);
    final nextNum = (int.tryParse(lastNumStr ?? '0') ?? 0) + 1;

    // نحفظ الرقم الجديد فوراً لكي يحترق (لا يُستخدم مجدداً حتى لو حذفت المسودة)
    await settingsDao.setValue(settingKey, nextNum.toString());
    return nextNum;
  }

  // ─── 4. حفظ الفاتورة (مسودة أو مُخرجة) مع أقلامها ───
  Future<int> saveInvoice(InvoicesCompanion invoice, List<InvoiceLinesCompanion> lines) async {
    return await db.transaction(() async {
      int invoiceId;

      if (!invoice.id.present) {
        // فاتورة جديدة كلياً
        final nextNum = await _getNextInvoiceNumber(invoice.type.value);
        final newInvoice = invoice.copyWith(
          invoiceNumber: Value(nextNum),
        );
        invoiceId = await db.into(db.invoices).insert(newInvoice);
      } else {
        // تحديث فاتورة موجودة (مسودة) - تم التصحيح لاستخدام write بدلاً من replace
        invoiceId = invoice.id.value;
        await (db.update(db.invoices)..where((t) => t.id.equals(invoiceId))).write(invoice);

        // نحذف الأقلام القديمة لنضع الجديدة (لأن المستخدم قد يكون حذف بعض الأقلام أثناء التعديل)
        await (db.delete(db.invoiceLines)..where((t) => t.invoiceId.equals(invoiceId))).go();
      }

      // إدراج الأقلام الجديدة
      for (int i = 0; i < lines.length; i++) {
        final lineWithInvoiceId = lines[i].copyWith(
          invoiceId: Value(invoiceId),
          lineOrder: Value(i),
        );
        await db.into(db.invoiceLines).insert(lineWithInvoiceId);
      }

      return invoiceId;
    });
  }

  // ─── 5. حذف الفاتورة (للمسودات فقط) ───
  Future<bool> deleteInvoice(int invoiceId) async {
    final invoice = await (db.select(db.invoices)..where((t) => t.id.equals(invoiceId))).getSingleOrNull();
    if (invoice == null || invoice.status == 'SENT') return false; // لا يمكن حذف المُرسلة

    await db.transaction(() async {
      await (db.delete(db.invoiceLines)..where((t) => t.invoiceId.equals(invoiceId))).go();
      await (db.delete(db.invoices)..where((t) => t.id.equals(invoiceId))).go();
    });
    return true;
  }

  // ─── 6. تخريج الفاتورة (تغيير الحالة فقط) ───
  Future<void> issueInvoice(int invoiceId) async {
    await (db.update(db.invoices)..where((t) => t.id.equals(invoiceId))).write(
      const InvoicesCompanion(status: Value('ISSUED')),
    );
  }
}

// المزود (Provider)
final invoicesDaoProvider = Provider<InvoicesDao>((ref) {
  return InvoicesDao(ref.watch(databaseProvider), ref.watch(settingsDaoProvider));
});