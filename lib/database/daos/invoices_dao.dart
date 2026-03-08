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

  // ─── 1. جلب الفواتير (للقوائم) مع الفلاتر ───
  Stream<List<Invoice>> watchInvoices(String type, String statusFilter, String paymentFilter, String sortFilter) {
    final query = db.select(db.invoices)..where((t) => t.type.equals(type));

    // فلتر الحالة (مُخرجة، مسودة، مُرسلة)
    if (statusFilter != 'ALL') {
      query.where((t) => t.status.equals(statusFilter));
    }
    // فلتر نوع الدفع (نقدي، آجل)
    if (paymentFilter != 'ALL') {
      query.where((t) => t.paymentMethod.equals(paymentFilter));
    }

    // الترتيب
    if (sortFilter == 'NEWEST') {
      query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]);
    } else if (sortFilter == 'OLDEST') {
      query.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)]);
    } else if (sortFilter == 'HIGH_AMOUNT') {
      query.orderBy([(t) => OrderingTerm(expression: t.total, mode: OrderingMode.desc)]);
    } else if (sortFilter == 'LOW_AMOUNT') {
      query.orderBy([(t) => OrderingTerm(expression: t.total, mode: OrderingMode.asc)]);
    }

    return query.watch();
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
          id: const Value.absent(), // 🔴 الحل السحري هنا: تفريغ الـ ID ليقوم النظام بتوليد ID جديد بعد الحذف
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

  // ─── 7. تحديث حالة الفواتير إلى مُرسلة ───
  Future<void> markUnsentAsSent() async {
    // نقوم بتحديث الفواتير المُخرجة (ISSUED) لتصبح مُرسلة (SENT)
    // لا نحدث الـ DRAFT لأنها ما زالت مسودة
    await (db.update(db.invoices)..where((t) => t.status.equals('ISSUED'))).write(
      const InvoicesCompanion(status: Value('SENT')),
    );
  }
}

// المزود (Provider)
final invoicesDaoProvider = Provider<InvoicesDao>((ref) {
  return InvoicesDao(ref.watch(databaseProvider), ref.watch(settingsDaoProvider));
});