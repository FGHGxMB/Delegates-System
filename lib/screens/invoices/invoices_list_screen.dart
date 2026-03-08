import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/database.dart';

// ─── مزود ذكي لفلاتر الفواتير ───
class InvoiceFilterState {
  final String statusFilter; // ALL, DRAFT, ISSUED, SENT
  final String paymentFilter; // ALL, CASH, CREDIT
  final String sortFilter; // NEWEST, OLDEST, HIGH_AMOUNT, LOW_AMOUNT
  InvoiceFilterState({this.statusFilter = 'ALL', this.paymentFilter = 'ALL', this.sortFilter = 'NEWEST'});
}

class InvoiceFilterNotifier extends StateNotifier<InvoiceFilterState> {
  final SettingsDao settingsDao;
  InvoiceFilterNotifier(this.settingsDao) : super(InvoiceFilterState()) { _load(); }

  Future<void> _load() async {
    state = InvoiceFilterState(
      statusFilter: await settingsDao.getValue('filter_inv_status') ?? 'ALL',
      paymentFilter: await settingsDao.getValue('filter_inv_pay') ?? 'ALL',
      sortFilter: await settingsDao.getValue('filter_inv_sort') ?? 'NEWEST',
    );
  }

  void setFilters(String status, String pay, String sort) {
    state = InvoiceFilterState(statusFilter: status, paymentFilter: pay, sortFilter: sort);
    settingsDao.setValue('filter_inv_status', status);
    settingsDao.setValue('filter_inv_pay', pay);
    settingsDao.setValue('filter_inv_sort', sort);
  }
}

final invoiceFilterProvider = StateNotifierProvider<InvoiceFilterNotifier, InvoiceFilterState>((ref) {
  return InvoiceFilterNotifier(ref.watch(settingsDaoProvider));
});
// ────────────────────────────────

class InvoicesListScreen extends ConsumerWidget {
  const InvoicesListScreen({Key? key}) : super(key: key);

  void _showFilter(BuildContext context, WidgetRef ref) {
    final current = ref.read(invoiceFilterProvider);
    String tStatus = current.statusFilter;
    String tPay = current.paymentFilter;
    String tSort = current.sortFilter;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text('حالة الفاتورة:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(spacing: 8, children:[
                    ChoiceChip(label: const Text('الجميع'), selected: tStatus == 'ALL', onSelected: (v) => setStateSheet(()=> tStatus='ALL')),
                    ChoiceChip(label: const Text('مسودة'), selected: tStatus == 'DRAFT', onSelected: (v) => setStateSheet(()=> tStatus='DRAFT')),
                    ChoiceChip(label: const Text('مُخرجة'), selected: tStatus == 'ISSUED', onSelected: (v) => setStateSheet(()=> tStatus='ISSUED')),
                    ChoiceChip(label: const Text('مُرسلة'), selected: tStatus == 'SENT', onSelected: (v) => setStateSheet(()=> tStatus='SENT')),
                  ]),
                  const SizedBox(height: 12),
                  const Text('طريقة الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(spacing: 8, children:[
                    ChoiceChip(label: const Text('الجميع'), selected: tPay == 'ALL', onSelected: (v) => setStateSheet(()=> tPay='ALL')),
                    ChoiceChip(label: const Text('نقدي'), selected: tPay == 'CASH', onSelected: (v) => setStateSheet(()=> tPay='CASH')),
                    ChoiceChip(label: const Text('آجل'), selected: tPay == 'CREDIT', onSelected: (v) => setStateSheet(()=> tPay='CREDIT')),
                  ]),
                  const SizedBox(height: 12),
                  const Text('الترتيب:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(spacing: 8, children:[
                    ChoiceChip(label: const Text('الأحدث'), selected: tSort == 'NEWEST', onSelected: (v) => setStateSheet(()=> tSort='NEWEST')),
                    ChoiceChip(label: const Text('الأقدم'), selected: tSort == 'OLDEST', onSelected: (v) => setStateSheet(()=> tSort='OLDEST')),
                    ChoiceChip(label: const Text('المبلغ الأكبر'), selected: tSort == 'HIGH_AMOUNT', onSelected: (v) => setStateSheet(()=> tSort='HIGH_AMOUNT')),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: () { ref.read(invoiceFilterProvider.notifier).setFilters(tStatus, tPay, tSort); Navigator.pop(ctx); }, child: const Text('تطبيق وحفظ'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(invoiceFilterProvider);
    bool hasActiveFilter = filter.statusFilter != 'ALL' || filter.paymentFilter != 'ALL' || filter.sortFilter != 'NEWEST';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.invoices),
          actions:[
            IconButton(
              icon: Icon(Icons.filter_list, color: hasActiveFilter ? Colors.orangeAccent : Colors.white),
              onPressed: () => _showFilter(context, ref),
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white, labelColor: Colors.white, unselectedLabelColor: Colors.white70,
            tabs:[Tab(text: 'المبيعات', icon: Icon(Icons.shopping_cart)), Tab(text: 'المرتجعات', icon: Icon(Icons.assignment_return))],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    ListTile(leading: const Icon(Icons.shopping_cart, color: AppColors.primary), title: const Text(AppStrings.newSalesInvoice), onTap: () { Navigator.pop(ctx); context.push('/invoice_form/SALE/0'); }),
                    ListTile(leading: const Icon(Icons.assignment_return, color: Colors.orange), title: const Text(AppStrings.newReturnInvoice), onTap: () { Navigator.pop(ctx); context.push('/invoice_form/RETURN/0'); }),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(children:[_InvoiceListTab(type: 'SALE'), _InvoiceListTab(type: 'RETURN')]),
      ),
    );
  }
}

class _InvoiceListTab extends ConsumerWidget {
  final String type;
  const _InvoiceListTab({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(invoicesDaoProvider);
    final filter = ref.watch(invoiceFilterProvider);

    return StreamBuilder<List<Invoice>>(
      stream: dao.watchInvoices(type, filter.statusFilter, filter.paymentFilter, filter.sortFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final invoices = snapshot.data ??[];

        if (invoices.isEmpty) return const Center(child: Text('لا توجد فواتير تطابق الفلتر'));

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];
            Color statusColor = AppColors.draftColor;
            String statusText = AppStrings.invoiceDraft;
            if (invoice.status == 'ISSUED') { statusColor = AppColors.issuedColor; statusText = AppStrings.invoiceIssued; }
            else if (invoice.status == 'SENT') { statusColor = AppColors.sentColor; statusText = AppStrings.invoiceSent; }

            return Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(backgroundColor: statusColor.withOpacity(0.2), child: Icon(type == 'SALE' ? Icons.shopping_cart : Icons.assignment_return, color: statusColor)),
                title: Text('فاتورة رقم: ${invoice.invoiceNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${invoice.date} | ${invoice.paymentMethod == 'CASH' ? 'نقدي' : 'آجل'} | ${invoice.total} ${invoice.currency}'),
                trailing: Chip(label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: statusColor),
                onTap: () => context.push('/invoice_form/${invoice.type}/${invoice.id}'),
              ),
            );
          },
        );
      },
    );
  }
}