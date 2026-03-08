// مسار الملف: lib/database/daos/dashboard_dao.dart

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';
import '../../../../screens/home/dashboard_stats.dart';

class DashboardDao {
  final AppDatabase db;
  DashboardDao(this.db);

  // ─── 🔴 تستقبل التاريخ وتراقب التغييرات ───
  Stream<DashboardStats> watchDashboardStats(DateTime targetDate) {
    return db.customSelect(
      'SELECT 1',
      readsFrom: {db.invoices, db.vouchers},
    ).watch().asyncMap((_) async {
      return await _calculateStats(targetDate); // نمرر التاريخ لدالة الحساب
    });
  }

  // ─── منطق حساب وتجميع الأرقام ───
  Future<DashboardStats> _calculateStats(DateTime targetDate) async {
    // 🔴 تحويل التاريخ المختار إلى الصيغة المعتمدة في قاعدة البيانات (YYYY-MM-DD)
    final String dateString = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

    Future<double> sumInvoicesToday(String paymentMethod, String currency) async {
      final sumExp = db.invoices.total.sum();
      final query = db.selectOnly(db.invoices)
        ..addColumns([sumExp])
        ..where(
            db.invoices.date.equals(dateString) & // 🔴 استخدام التاريخ الممرر
            db.invoices.type.equals('SALE') &
            db.invoices.status.isNotIn(['DRAFT']) &
            db.invoices.paymentMethod.equals(paymentMethod) &
            db.invoices.currency.equals(currency)
        );
      final result = await query.getSingle();
      return result.read(sumExp) ?? 0.0;
    }

    Future<double> sumVouchersToday(String type, String currency) async {
      final sumExp = db.vouchers.amount.sum();
      final query = db.selectOnly(db.vouchers)
        ..addColumns([sumExp])
        ..where(
            db.vouchers.date.equals(dateString) & // 🔴 استخدام التاريخ الممرر
            db.vouchers.type.equals(type) &
            db.vouchers.status.isNotIn(['DRAFT']) &
            db.vouchers.currency.equals(currency)
        );
      final result = await query.getSingle();
      return result.read(sumExp) ?? 0.0;
    }

    // الرصيد الحي (لا يتأثر بالتاريخ، يحسب كل الأيام)
    Future<double> getLiveBoxBalance(String currency) async {
      final sumSalesExp = db.invoices.total.sum();
      final salesQuery = db.selectOnly(db.invoices)
        ..addColumns([sumSalesExp])
        ..where(db.invoices.type.equals('SALE') & db.invoices.status.isNotIn(['DRAFT']) & db.invoices.paymentMethod.equals('CASH') & db.invoices.currency.equals(currency));
      final totalCashSales = (await salesQuery.getSingle()).read(sumSalesExp) ?? 0.0;

      final returnsQuery = db.selectOnly(db.invoices)
        ..addColumns([sumSalesExp])
        ..where(db.invoices.type.equals('RETURN') & db.invoices.status.isNotIn(['DRAFT']) & db.invoices.paymentMethod.equals('CASH') & db.invoices.currency.equals(currency));
      final totalCashReturns = (await returnsQuery.getSingle()).read(sumSalesExp) ?? 0.0;

      final sumVouchersExp = db.vouchers.amount.sum();
      final receiptsQuery = db.selectOnly(db.vouchers)
        ..addColumns([sumVouchersExp])
        ..where(db.vouchers.type.equals('RECEIPT') & db.vouchers.status.isNotIn(['DRAFT']) & db.vouchers.currency.equals(currency));
      final totalReceipts = (await receiptsQuery.getSingle()).read(sumVouchersExp) ?? 0.0;

      final paymentsQuery = db.selectOnly(db.vouchers)
        ..addColumns([sumVouchersExp])
        ..where(db.vouchers.type.equals('PAYMENT') & db.vouchers.status.isNotIn(['DRAFT']) & db.vouchers.currency.equals(currency));
      final totalPayments = (await paymentsQuery.getSingle()).read(sumVouchersExp) ?? 0.0;

      return (totalCashSales + totalReceipts) - (totalCashReturns + totalPayments);
    }

    // 1. أعداد الفواتير لليوم المختار
    final invoicesCountQuery = await (db.select(db.invoices)
      ..where((t) => t.date.equals(dateString) & t.type.equals('SALE') & t.status.isNotIn(['DRAFT'])))
        .get();

    final totalInvoices = invoicesCountQuery.length;
    final cashInvoicesCount = invoicesCountQuery.where((i) => i.paymentMethod == 'CASH').length;
    final creditInvoicesCount = invoicesCountQuery.where((i) => i.paymentMethod == 'CREDIT').length;

    // 2. زيادة الديون
    final debtIncreaseSYP = await sumInvoicesToday('CREDIT', 'SYP');
    final debtIncreaseUSD = await sumInvoicesToday('CREDIT', 'USD');

    // 3. الديون المحصلة
    final debtCollectedSYP = await sumVouchersToday('RECEIPT', 'SYP');
    final debtCollectedUSD = await sumVouchersToday('RECEIPT', 'USD');

    // 4. المبيعات النقدية والتحصيلات
    final cashSalesSYP = await sumInvoicesToday('CASH', 'SYP');
    final cashSalesUSD = await sumInvoicesToday('CASH', 'USD');

    final collectionsSYP = cashSalesSYP + debtCollectedSYP;
    final collectionsUSD = cashSalesUSD + debtCollectedUSD;

    // 5. المدفوعات
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

final dashboardDaoProvider = Provider<DashboardDao>((ref) {
  final db = ref.watch(databaseProvider);
  return DashboardDao(db);
});