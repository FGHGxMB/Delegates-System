import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/database.dart';

class CustomersListScreen extends ConsumerStatefulWidget {
  const CustomersListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends ConsumerState<CustomersListScreen> {
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(customersDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customers),
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
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/customer_form/0'), // 0 تعني زبون جديد
        child: const Icon(Icons.person_add),
      ),
      body: StreamBuilder<List<Customer>>(
        stream: dao.watchCustomers(_searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final customers = snapshot.data ??[];

          if (customers.isEmpty) {
            return Center(child: Text(_searchQuery.isEmpty ? AppStrings.noData : 'لا توجد نتائج للبحث'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Text(customer.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${customer.accountCode} | ${customer.currency} | ${customer.city ?? ""}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary),
                        onPressed: () => context.push('/customer_form/${customer.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(AppStrings.warning),
                                content: const Text('هل أنت متأكد من حذف هذا الزبون؟'),
                                actions:[
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.no)),
                                  FilledButton(
                                      style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text(AppStrings.yes)
                                  ),
                                ],
                              )
                          );
                          if (confirm == true) await dao.deleteCustomer(customer.id);
                        },
                      ),
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