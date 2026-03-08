// مسار الملف: lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // دالة مساعدة لاختيار التاريخ
  Future<void> _pickDate(BuildContext context, WidgetRef ref, DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade800, // لون الأزرار
              onPrimary: Colors.white, // لون النص داخل الأزرار
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(dashboardDateProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardStatsProvider);
    final selectedDate = ref.watch(dashboardDateProvider);

    final now = DateTime.now();
    // التحقق عما إذا كان التاريخ المختار هو تاريخ اليوم الفعلي
    final isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('الملخص المالي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('حدث خطأ في جلب البيانات:\n$error', textAlign: TextAlign.center)),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardStatsProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers:[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children:[
                        // ─── 🔴 شريط اختيار التاريخ الذكي ───
                        InkWell(
                          onTap: () => _pickDate(context, ref, selectedDate),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              // تغيير اللون للبرتقالي الفاتح لتنبيه المستخدم أنه في يوم سابق
                                color: isToday ? Colors.white : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isToday ? Colors.grey.shade300 : Colors.orange.shade300,
                                  width: 1.5,
                                ),
                                boxShadow:[
                                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                                ]
                            ),
                            child: Row(
                              children:[
                                Icon(Icons.calendar_month, color: isToday ? Colors.blue.shade700 : Colors.orange.shade800),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text(
                                        isToday ? 'إحصائيات اليوم الحالي' : 'إحصائيات يوم سابق',
                                        style: TextStyle(fontSize: 12, color: isToday ? Colors.grey.shade600 : Colors.orange.shade800, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isToday ? Colors.black87 : Colors.orange.shade900),
                                      ),
                                    ],
                                  ),
                                ),
                                // زر العودة السريعة لليوم
                                if (!isToday)
                                  TextButton.icon(
                                    icon: const Icon(Icons.restore, size: 18),
                                    label: const Text('العودة لليوم'),
                                    onPressed: () => ref.read(dashboardDateProvider.notifier).state = DateTime.now(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red.shade800,
                                      padding: EdgeInsets.zero, // ✅ تم نقلها إلى هنا بشكل صحيح
                                    ),
                                  ),
                                if (isToday)
                                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle('أرصدة الصناديق الحالية (Live)'),
                      const SizedBox(height: 8),
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

                      _buildSectionTitle('فواتير التاريخ المختار (المعتمدة)'),
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

                      _buildSectionTitle('الحركة المالية للتاريخ المختار'),
                      const SizedBox(height: 8),
                    ]),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
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

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }
}

// ─── باقي الكلاسات المساعدة (BalanceCard, CountCard, FinancialCard) تبقى كما هي لديك ───
// يرجى نسخها كما كانت من الكود الأصلي ولصقها هنا أسفل الملف
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

String _formatNumber(double number) {
  if (number == number.truncateToDouble()) {
    return number.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
  return number.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}