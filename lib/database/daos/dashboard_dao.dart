// مسار الملف المقترح: lib/screens/home/data/dashboard_dao.dart

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database.dart'; // مسار ملف AppDatabase الخاص بك
import '../../../../providers/database_provider.dart'; // مسار الـ databaseProvider
import '../../../../screens/home/dashboard_stats.dart'; // مسار المودل الذي أنشأناه بالأعلى

class DashboardDao {
  final AppDatabase db;
  DashboardDao(this.db);

  // ─── الدالة السحرية المحدثة: تراقب الجداول وتعيد البيانات لحظياً ───
  Stream<DashboardStats> watchTodayDashboardStats() {
    // نستخدم استعلام وهمي سريع جداً، وظيفته الوحيدة هي الاستماع لتغيرات جداول الفواتير والسندات
    return db.customSelect(
      'SELECT 1',
      readsFrom: {db.invoices, db.vouchers}, // الجداول المراقبة
    ).watch().asyncMap((_) async {
      // هذه الدالة ستعمل تلقائياً عند فتح الشاشة، وعند أي إضافة/حذف/تعديل في الفواتير أو السندات
      return await _calculateStats();
    });
  }

  // ─── منطق حساب وتجميع الأرقام ───
  Future<DashboardStats> _calculateStats() async {
    // 1. جلب تاريخ اليوم بصيغة YYYY-MM-DD
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // -- دوال مساعدة لاستخراج المجاميع باستخدام Drift Aggregation --

    // دالة لجمع مبالغ الفواتير حسب شروط معينة لليوم الحالي
    Future<double> sumInvoicesToday(String paymentMethod, String currency) async {
      final sumExp = db.invoices.total.sum();
      final query = db.selectOnly(db.invoices)
        ..addColumns([sumExp])
        ..where(
            db.invoices.date.equals(today) &
            db.invoices.type.equals('SALE') &
            db.invoices.status.isNotIn(['DRAFT']) & // استثناء المسودات
            db.invoices.paymentMethod.equals(paymentMethod) &
            db.invoices.currency.equals(currency)
        );
      final result = await query.getSingle();
      return result.read(sumExp) ?? 0.0;
    }

    // دالة لجمع مبالغ السندات حسب شروط معينة لليوم الحالي
    Future<double> sumVouchersToday(String type, String currency) async {
      final sumExp = db.vouchers.amount.sum();
      final query = db.selectOnly(db.vouchers)
        ..addColumns([sumExp])
        ..where(
            db.vouchers.date.equals(today) &
            db.vouchers.type.equals(type) &
            db.vouchers.status.isNotIn(['DRAFT']) & // استثناء المسودات
            db.vouchers.currency.equals(currency)
        );
      final result = await query.getSingle();
      return result.read(sumExp) ?? 0.0;
    }

    // دالة لحساب الرصيد الحي للصندوق (لكل الأيام، وليس اليوم فقط)
    Future<double> getLiveBoxBalance(String currency) async {
      // الصندوق يدخله: (مبيعات نقدية) + (سندات قبض)
      // الصندوق يخرج منه: (مرتجعات نقدية) + (سندات دفع)
      // ملاحظة: سنفترض هنا أن مبالغ الفواتير النقدية والسندات تدخل الصندوق مباشرة.

      // إجمالي المبيعات النقدية
      final sumSalesExp = db.invoices.total.sum();
      final salesQuery = db.selectOnly(db.invoices)
        ..addColumns([sumSalesExp])
        ..where(db.invoices.type.equals('SALE') & db.invoices.status.isNotIn(['DRAFT']) & db.invoices.paymentMethod.equals('CASH') & db.invoices.currency.equals(currency));
      final totalCashSales = (await salesQuery.getSingle()).read(sumSalesExp) ?? 0.0;

      // إجمالي المرتجعات النقدية (إن وجدت)
      final returnsQuery = db.selectOnly(db.invoices)
        ..addColumns([sumSalesExp])
        ..where(db.invoices.type.equals('RETURN') & db.invoices.status.isNotIn(['DRAFT']) & db.invoices.paymentMethod.equals('CASH') & db.invoices.currency.equals(currency));
      final totalCashReturns = (await returnsQuery.getSingle()).read(sumSalesExp) ?? 0.0;

      // إجمالي سندات القبض
      final sumVouchersExp = db.vouchers.amount.sum();
      final receiptsQuery = db.selectOnly(db.vouchers)
        ..addColumns([sumVouchersExp])
        ..where(db.vouchers.type.equals('RECEIPT') & db.vouchers.status.isNotIn(['DRAFT']) & db.vouchers.currency.equals(currency));
      final totalReceipts = (await receiptsQuery.getSingle()).read(sumVouchersExp) ?? 0.0;

      // إجمالي سندات الدفع
      final paymentsQuery = db.selectOnly(db.vouchers)
        ..addColumns([sumVouchersExp])
        ..where(db.vouchers.type.equals('PAYMENT') & db.vouchers.status.isNotIn(['DRAFT']) & db.vouchers.currency.equals(currency));
      final totalPayments = (await paymentsQuery.getSingle()).read(sumVouchersExp) ?? 0.0;

      return (totalCashSales + totalReceipts) - (totalCashReturns + totalPayments);
    }

    // ─── تنفيذ الاستعلامات ───

    // 1. أعداد الفواتير لليوم
    final invoicesCountQuery = await (db.select(db.invoices)
      ..where((t) => t.date.equals(today) & t.type.equals('SALE') & t.status.isNotIn(['DRAFT'])))
        .get();

    final totalInvoices = invoicesCountQuery.length;
    final cashInvoicesCount = invoicesCountQuery.where((i) => i.paymentMethod == 'CASH').length;
    final creditInvoicesCount = invoicesCountQuery.where((i) => i.paymentMethod == 'CREDIT').length;

    // 2. زيادة الديون (المبيعات الآجلة)
    final debtIncreaseSYP = await sumInvoicesToday('CREDIT', 'SYP');
    final debtIncreaseUSD = await sumInvoicesToday('CREDIT', 'USD');

    // 3. الديون المحصلة (سندات القبض)
    final debtCollectedSYP = await sumVouchersToday('RECEIPT', 'SYP');
    final debtCollectedUSD = await sumVouchersToday('RECEIPT', 'USD');

    // 4. المبيعات النقدية
    final cashSalesSYP = await sumInvoicesToday('CASH', 'SYP');
    final cashSalesUSD = await sumInvoicesToday('CASH', 'USD');

    // إجمالي التحصيلات = المبيعات النقدية + الديون المحصلة (سندات القبض)
    final collectionsSYP = cashSalesSYP + debtCollectedSYP;
    final collectionsUSD = cashSalesUSD + debtCollectedUSD;

    // 5. المدفوعات (سندات الدفع)
    final paymentsSYP = await sumVouchersToday('PAYMENT', 'SYP');
    final paymentsUSD = await sumVouchersToday('PAYMENT', 'USD');

    // 6. الأرصدة الحية
    final liveBalanceSYP = await getLiveBoxBalance('SYP');
    final liveBalanceUSD = await getLiveBoxBalance('USD');

    return DashboardStats(
      totalInvoices: totalInvoices,
      cashInvoicesCount: cashInvoicesCount,
      creditInvoicesCount: creditInvoicesCount,
      collectionsSYP: collectionsSYP,
      collectionsUSD: collectionsUSD,
      debtIncreaseSYP: debtIncreaseSYP,
      debtIncreaseUSD: debtIncreaseUSD,
      debtCollectedSYP: debtCollectedSYP,
      debtCollectedUSD: debtCollectedUSD,
      paymentsSYP: paymentsSYP,
      paymentsUSD: paymentsUSD,
      liveBalanceSYP: liveBalanceSYP,
      liveBalanceUSD: liveBalanceUSD,
    );
  }
}

// ─── Provider للـ DAO ───
final dashboardDaoProvider = Provider<DashboardDao>((ref) {
  final db = ref.watch(databaseProvider);
  return DashboardDao(db);
});