import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../database/database.dart';
import '../../database/daos/vouchers_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../utils/currency_utils.dart';

// ─── مزود ذكي لفلاتر السندات ───
class VoucherFilterState {
  final String typeFilter; // ALL, RECEIPT, PAYMENT
  final String sortFilter; // NEWEST, OLDEST, HIGH_AMOUNT, LOW_AMOUNT
  VoucherFilterState({this.typeFilter = 'ALL', this.sortFilter = 'NEWEST'});
}

class VoucherFilterNotifier extends StateNotifier<VoucherFilterState> {
  final SettingsDao settingsDao;
  VoucherFilterNotifier(this.settingsDao) : super(VoucherFilterState()) { _load(); }

  Future<void> _load() async {
    state = VoucherFilterState(
      typeFilter: await settingsDao.getValue('filter_vouch_type') ?? 'ALL',
      sortFilter: await settingsDao.getValue('filter_vouch_sort') ?? 'NEWEST',
    );
  }

  void setFilters(String type, String sort) {
    state = VoucherFilterState(typeFilter: type, sortFilter: sort);
    settingsDao.setValue('filter_vouch_type', type);
    settingsDao.setValue('filter_vouch_sort', sort);
  }
}

final voucherFilterProvider = StateNotifierProvider<VoucherFilterNotifier, VoucherFilterState>((ref) {
  return VoucherFilterNotifier(ref.watch(settingsDaoProvider));
});
// ────────────────────────────────

class VouchersListScreen extends ConsumerWidget {
  const VouchersListScreen({Key? key}) : super(key: key);

  void _showFilter(BuildContext context, WidgetRef ref) {
    final current = ref.read(voucherFilterProvider);
    String tType = current.typeFilter;
    String tSort = current.sortFilter;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const Text('نوع السند:', style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(spacing: 8, children:[
                  ChoiceChip(label: const Text('الجميع'), selected: tType == 'ALL', onSelected: (v) => setStateSheet(()=> tType='ALL')),
                  ChoiceChip(label: const Text('سندات قبض'), selected: tType == 'RECEIPT', onSelected: (v) => setStateSheet(()=> tType='RECEIPT')),
                  ChoiceChip(label: const Text('سندات دفع'), selected: tType == 'PAYMENT', onSelected: (v) => setStateSheet(()=> tType='PAYMENT')),
                ]),
                const SizedBox(height: 12),
                const Text('الترتيب:', style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(spacing: 8, children:[
                  ChoiceChip(label: const Text('الأحدث'), selected: tSort == 'NEWEST', onSelected: (v) => setStateSheet(()=> tSort='NEWEST')),
                  ChoiceChip(label: const Text('الأقدم'), selected: tSort == 'OLDEST', onSelected: (v) => setStateSheet(()=> tSort='OLDEST')),
                  ChoiceChip(label: const Text('المبلغ الأكبر'), selected: tSort == 'HIGH_AMOUNT', onSelected: (v) => setStateSheet(()=> tSort='HIGH_AMOUNT')),
                ]),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: FilledButton(onPressed: () { ref.read(voucherFilterProvider.notifier).setFilters(tType, tSort); Navigator.pop(ctx); }, child: const Text('تطبيق وحفظ'))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersDao = ref.watch(vouchersDaoProvider);
    final filter = ref.watch(voucherFilterProvider);
    bool hasActiveFilter = filter.typeFilter != 'ALL' || filter.sortFilter != 'NEWEST';

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل السندات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions:[
          IconButton(
            icon: Icon(Icons.filter_list, color: hasActiveFilter ? Colors.orangeAccent : Colors.white),
            onPressed: () => _showFilter(context, ref),
          )
        ],
      ),
      body: StreamBuilder<List<Voucher>>(
        stream: vouchersDao.watchAllVouchers(filter.typeFilter, filter.sortFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final vouchers = snapshot.data ??[];

          if (vouchers.isEmpty) return const Center(child: Text('لا توجد سندات مسجلة تطابق الفلتر.', style: TextStyle(color: Colors.grey, fontSize: 16)));

          return ListView.builder(
            padding: const EdgeInsets.all(8).copyWith(bottom: 80),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              final isReceipt = voucher.type == 'RECEIPT';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isReceipt ? AppColors.success.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5), width: 1),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isReceipt ? AppColors.success.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                    child: Icon(isReceipt ? Icons.arrow_downward : Icons.arrow_upward, color: isReceipt ? AppColors.success : Colors.redAccent),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(isReceipt ? 'سند قبض #${voucher.voucherNumber}' : 'سند دفع #${voucher.voucherNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text(voucher.status == 'DRAFT' ? AppStrings.invoiceDraft : voucher.status == 'ISSUED' ? AppStrings.invoiceIssued : AppStrings.invoiceSent, style: const TextStyle(color: Colors.white, fontSize: 10)),
                        backgroundColor: voucher.status == 'DRAFT' ? AppColors.draftColor : voucher.status == 'ISSUED' ? AppColors.issuedColor : AppColors.sentColor,
                        visualDensity: VisualDensity.compact, padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const SizedBox(height: 4),
                      Text('التاريخ: ${voucher.date}'),
                      const SizedBox(height: 4),
                      Text('المبلغ: ${CurrencyUtils.format(voucher.amount)} ${voucher.currency == 'SYP' ? 'ل.س' : '\$'}', style: TextStyle(fontWeight: FontWeight.bold, color: isReceipt ? AppColors.success : Colors.redAccent, fontSize: 15)),
                    ],
                  ),
                  onTap: () => context.push('/voucher_form/${voucher.type}/${voucher.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  const Padding(padding: EdgeInsets.all(16.0), child: Text('اختر نوع السند', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ListTile(leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.arrow_downward, color: Colors.white)), title: const Text('سند قبض (استلام مبلغ)'), onTap: () { Navigator.pop(ctx); context.push('/voucher_form/RECEIPT/0'); }),
                  const Divider(),
                  ListTile(leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.arrow_upward, color: Colors.white)), title: const Text('سند دفع (دفع مبلغ)'), onTap: () { Navigator.pop(ctx); context.push('/voucher_form/PAYMENT/0'); }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('سند جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}