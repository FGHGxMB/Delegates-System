import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // الاستماع للبيانات الحية
    final dashboardState = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // لون خلفية مريح للعين
      appBar: AppBar(
        title: const Text('إحصائيات اليوم الحية', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('حدث خطأ في جلب البيانات:\n$error', textAlign: TextAlign.center),
        ),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () async {
              // فقط لتحديث الواجهة يدوياً إن رغب المستخدم، رغم أن البيانات حية
              ref.invalidate(dashboardStatsProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers:[
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle('أرصدة الصناديق الحالية (Live)'),
                      const SizedBox(height: 8),
                      // بطاقات الصناديق (تأخذ عرض الشاشة مقسماً على 2)
                      Row(
                        children:[
                          Expanded(
                            child: _BalanceCard(
                              title: 'الصندوق (SYP)',
                              amount: stats.liveBalanceSYP,
                              currency: 'ل.س',
                              icon: Icons.account_balance_wallet,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BalanceCard(
                              title: 'الصندوق (USD)',
                              amount: stats.liveBalanceUSD,
                              currency: '\$',
                              icon: Icons.monetization_on,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildSectionTitle('فواتير اليوم (المعتمدة)'),
                      const SizedBox(height: 8),
                      Row(
                        children:[
                          Expanded(child: _CountCard(title: 'الإجمالي', count: stats.totalInvoices, icon: Icons.receipt_long, color: Colors.blueAccent)),
                          const SizedBox(width: 8),
                          Expanded(child: _CountCard(title: 'نقدي', count: stats.cashInvoicesCount, icon: Icons.money, color: Colors.green)),
                          const SizedBox(width: 8),
                          Expanded(child: _CountCard(title: 'آجل', count: stats.creditInvoicesCount, icon: Icons.credit_score, color: Colors.orange)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildSectionTitle('الحركة المالية لليوم'),
                      const SizedBox(height: 8),
                    ]),
                  ),
                ),

                // شبكة البطاقات المالية
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2, // عمودين
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1, // التناسب لتبدو البطاقة بشكل شبه مربع
                    children:[
                      _FinancialCard(
                        title: 'التحصيلات النقدية',
                        subtitle: '(مبيعات نقدي + سندات قبض)',
                        sypAmount: stats.collectionsSYP,
                        usdAmount: stats.collectionsUSD,
                        icon: Icons.price_check,
                        color: Colors.green.shade600,
                      ),
                      _FinancialCard(
                        title: 'زيادة الديون',
                        subtitle: '(المبيعات الآجلة اليوم)',
                        sypAmount: stats.debtIncreaseSYP,
                        usdAmount: stats.debtIncreaseUSD,
                        icon: Icons.trending_up,
                        color: Colors.redAccent,
                      ),
                      _FinancialCard(
                        title: 'الديون المحصلة',
                        subtitle: '(سندات القبض المسددة)',
                        sypAmount: stats.debtCollectedSYP,
                        usdAmount: stats.debtCollectedUSD,
                        icon: Icons.assignment_return,
                        color: Colors.blue.shade600,
                      ),
                      _FinancialCard(
                        title: 'المدفوعات',
                        subtitle: '(سندات الدفع / مصاريف)',
                        sypAmount: stats.paymentsSYP,
                        usdAmount: stats.paymentsUSD,
                        icon: Icons.outbox,
                        color: Colors.orange.shade600,
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ودجت مساعد لعنوان الأقسام
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }
}

// ─── كلاسات البطاقات المخصصة للواجهة ───

// 1. بطاقة الرصيد الحي للصندوق
class _BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final IconData icon;
  final Color color;

  const _BalanceCard({required this.title, required this.amount, required this.currency, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:[
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${_formatNumber(amount)} $currency',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. بطاقة عداد الفواتير
class _CountCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _CountCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children:[
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(count.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

// 3. البطاقة المالية التفصيلية (تعرض SYP و USD معاً)
class _FinancialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double sypAmount;
  final double usdAmount;
  final IconData icon;
  final Color color;

  const _FinancialCard({
    required this.title, required this.subtitle, required this.sypAmount, required this.usdAmount, required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow:[
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
        ],
        border: Border(bottom: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children:[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const Spacer(),
          // قسم السوري
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              const Text('ل.س', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  _formatNumber(sypAmount),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 8, thickness: 0.5),
          // قسم الدولار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              const Text('\$', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  _formatNumber(usdAmount),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// دالة بسيطة لتنسيق الأرقام (إزالة الأصفار العشرية إن كان الرقم صحيحاً لتنظيف العرض)
String _formatNumber(double number) {
  // إذا كنت تستخدم حزمة intl يمكنك استخدام: NumberFormat('#,##0.##').format(number)
  if (number == number.truncateToDouble()) {
    return number.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
  return number.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}