// مسار الملف المقترح: lib/screens/home/models/dashboard_stats.dart

class DashboardStats {
  // 1. عدد الفواتير
  final int totalInvoices;
  final int cashInvoicesCount;
  final int creditInvoicesCount;

  // 2. التحصيلات النقدية اليوم (مبالغ الفواتير النقدية + سندات القبض)
  final double collectionsSYP;
  final double collectionsUSD;

  // 3. زيادة الديون اليوم (مبالغ الفواتير الآجلة)
  final double debtIncreaseSYP;
  final double debtIncreaseUSD;

  // 4. الديون المحصلة اليوم (سندات القبض فقط)
  final double debtCollectedSYP;
  final double debtCollectedUSD;

  // 5. المدفوعات اليوم (سندات الدفع)
  final double paymentsSYP;
  final double paymentsUSD;

  // 6. أرصدة الصناديق الحالية (لكل الأوقات وليس لليوم فقط)
  final double liveBalanceSYP;
  final double liveBalanceUSD;

  DashboardStats({
    required this.totalInvoices,
    required this.cashInvoicesCount,
    required this.creditInvoicesCount,
    required this.collectionsSYP,
    required this.collectionsUSD,
    required this.debtIncreaseSYP,
    required this.debtIncreaseUSD,
    required this.debtCollectedSYP,
    required this.debtCollectedUSD,
    required this.paymentsSYP,
    required this.paymentsUSD,
    required this.liveBalanceSYP,
    required this.liveBalanceUSD,
  });

  // حالة افتراضية للتحميل
  factory DashboardStats.empty() {
    return DashboardStats(
      totalInvoices: 0, cashInvoicesCount: 0, creditInvoicesCount: 0,
      collectionsSYP: 0, collectionsUSD: 0, debtIncreaseSYP: 0,
      debtIncreaseUSD: 0, debtCollectedSYP: 0, debtCollectedUSD: 0,
      paymentsSYP: 0, paymentsUSD: 0, liveBalanceSYP: 0, liveBalanceUSD: 0,
    );
  }
}