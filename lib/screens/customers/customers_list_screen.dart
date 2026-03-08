import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/database.dart';

// ─── مزود ذكي لحفظ وإدارة حالة الفلاتر للزبائن ───
class CustomerFilterState {
  final String showFilter; // ALL, HAS_DEBT, CLEAN
  final String sortFilter; // NAME_ASC, NAME_DESC, BAL_DESC, BAL_ASC
  CustomerFilterState({this.showFilter = 'ALL', this.sortFilter = 'NAME_ASC'});
}

class CustomerFilterNotifier extends StateNotifier<CustomerFilterState> {
  final SettingsDao settingsDao;

  CustomerFilterNotifier(this.settingsDao) : super(CustomerFilterState()) {
    _loadSavedFilters();
  }

  Future<void> _loadSavedFilters() async {
    final show = await settingsDao.getValue('filter_cust_show') ?? 'ALL';
    final sort = await settingsDao.getValue('filter_cust_sort') ?? 'NAME_ASC';
    state = CustomerFilterState(showFilter: show, sortFilter: sort);
  }

  void setFilters(String show, String sort) {
    state = CustomerFilterState(showFilter: show, sortFilter: sort);
    settingsDao.setValue('filter_cust_show', show);
    settingsDao.setValue('filter_cust_sort', sort);
  }
}

final customerFilterProvider = StateNotifierProvider<CustomerFilterNotifier, CustomerFilterState>((ref) {
  return CustomerFilterNotifier(ref.watch(settingsDaoProvider));
});
// ────────────────────────────────────────────────

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  void _showFilterBottomSheet(CustomerFilterState currentFilter) {
    String tempShow = currentFilter.showFilter;
    String tempSort = currentFilter.sortFilter;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text('إظهار الزبائن:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:[
                      ChoiceChip(label: const Text('الجميع'), selected: tempShow == 'ALL', onSelected: (v) => setSheetState(() => tempShow = 'ALL')),
                      ChoiceChip(label: const Text('المديونين فقط'), selected: tempShow == 'HAS_DEBT', onSelected: (v) => setSheetState(() => tempShow = 'HAS_DEBT'), selectedColor: Colors.red.shade100),
                      ChoiceChip(label: const Text('حسابهم نظيف'), selected: tempShow == 'CLEAN', onSelected: (v) => setSheetState(() => tempShow = 'CLEAN'), selectedColor: Colors.green.shade100),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('ترتيب حسب:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:[
                      ChoiceChip(label: const Text('الاسم (أ-ي)'), selected: tempSort == 'NAME_ASC', onSelected: (v) => setSheetState(() => tempSort = 'NAME_ASC')),
                      ChoiceChip(label: const Text('الاسم (ي-أ)'), selected: tempSort == 'NAME_DESC', onSelected: (v) => setSheetState(() => tempSort = 'NAME_DESC')),
                      ChoiceChip(label: const Text('الأكثر ديناً'), selected: tempSort == 'BAL_DESC', onSelected: (v) => setSheetState(() => tempSort = 'BAL_DESC')),
                      ChoiceChip(label: const Text('الأقل ديناً'), selected: tempSort == 'BAL_ASC', onSelected: (v) => setSheetState(() => tempSort = 'BAL_ASC')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ref.read(customerFilterProvider.notifier).setFilters(tempShow, tempSort);
                        Navigator.pop(ctx);
                      },
                      child: const Text('تطبيق الفلتر وحفظه كافتراضي'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(customersDaoProvider);
    final filterState = ref.watch(customerFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customers),
        actions:[
          IconButton(
            icon: Icon(Icons.filter_list, color: filterState.showFilter != 'ALL' || filterState.sortFilter != 'NAME_ASC' ? Colors.orangeAccent : Colors.white),
            tooltip: 'فلاتر وترتيب',
            onPressed: () => _showFilterBottomSheet(filterState),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: AppStrings.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); }) : null,
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push('/customer_form/0'), child: const Icon(Icons.person_add)),
      body: StreamBuilder<List<CustomerWithBalance>>(
        stream: dao.watchCustomersWithBalances(_searchQuery, filterState.showFilter, filterState.sortFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data ??[];

          if (items.isEmpty) return Center(child: Text(_searchQuery.isEmpty ? 'لا يوجد زبائن يطابقون الفلتر الحالي' : 'لا توجد نتائج للبحث'));

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final customer = item.customer;
              final balance = item.netBalance;
              final balanceColor = balance > 0 ? Colors.red.shade700 : Colors.green.shade700;

              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: AppColors.primaryLight, child: Text(customer.name.substring(0, 1), style: const TextStyle(color: Colors.white))),
                  title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${customer.accountCode} | ${customer.city ?? ""}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:[
                          const Text('الرصيد', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            '${balance.abs().toStringAsFixed(1)} ${customer.currency}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: balanceColor),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.edit, color: AppColors.primary), onPressed: () => context.push('/customer_form/${customer.id}')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}