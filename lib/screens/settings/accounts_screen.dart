import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/database.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(accountsDaoProvider).initDefaultAccounts());
  }

  // نافذة الإضافة والتعديل المدمجة
  Future<void> _showAccountDialog({Account? existing}) async {
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    String currency = existing?.currency ?? 'SYP';
    String type = existing?.accountType ?? 'GENERAL';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(existing == null ? AppStrings.addAccount : 'تعديل الحساب'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: AppStrings.accountCode),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: AppStrings.accountName),
                ),
                const SizedBox(height: 16),

                const Text('تصنيف الحساب', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: type,
                  items: const[
                    DropdownMenuItem(value: 'CASH', child: Text('صندوق / بنك')),
                    DropdownMenuItem(value: 'EXPENSE', child: Text('مصروفات (يظهر في دفع)')),
                    DropdownMenuItem(value: 'REVENUE', child: Text('إيرادات (يظهر في قبض)')),
                    DropdownMenuItem(value: 'GENERAL', child: Text('عام')),
                  ],
                  onChanged: (val) => setStateDialog(() => type = val!),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),

                const Text(AppStrings.currency, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const[
                    ButtonSegment(value: 'SYP', label: Text('ل.س')),
                    ButtonSegment(value: 'USD', label: Text('\$')),
                    ButtonSegment(value: 'BOTH', label: Text('كلاهما')),
                  ],
                  selected: {currency},
                  onSelectionChanged: (set) => setStateDialog(() => currency = set.first),
                ),
              ],
            ),
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
            FilledButton(
              onPressed: () async {
                if (codeCtrl.text.trim().isEmpty || nameCtrl.text.trim().isEmpty) return;

                final dao = ref.read(accountsDaoProvider);

                // [جديد] التحقق من التكرار
                final exists = await dao.isCodeOrNameExists(codeCtrl.text.trim(), nameCtrl.text.trim(), existing?.id ?? 0);
                if (exists && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.nameOrCodeExists), backgroundColor: Colors.red));
                  return; // يمنع الحفظ ولا يغلق النافذة
                }

                final newAccount = Account(
                  id: existing?.id ?? 0,
                  code: codeCtrl.text.trim(),
                  name: nameCtrl.text.trim(),
                  currency: currency,
                  accountType: type,
                  isSystem: existing?.isSystem ?? false,
                  isActive: existing?.isActive ?? true,
                  displayOrder: existing?.displayOrder ?? 999,
                );

                await dao.saveAccount(newAccount);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(accountsDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageAccounts),
        backgroundColor: Colors.red[800],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        onPressed: () => _showAccountDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children:[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(AppStrings.dragToReorder, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: StreamBuilder<List<Account>>(
              stream: dao.watchAllAccounts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final accounts = snapshot.data!;

                if (accounts.isEmpty) return const Center(child: Text(AppStrings.noData));

                return ReorderableListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: accounts.length,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = accounts.removeAt(oldIndex);
                    accounts.insert(newIndex, item);
                    await dao.updateAccountsOrder(accounts);
                  },
                  itemBuilder: (context, index) {
                    final account = accounts[index];

                    // تحديد الأيقونة حسب نوع الحساب
                    IconData accIcon = Icons.account_balance_wallet;
                    if (account.accountType == 'EXPENSE') accIcon = Icons.trending_down;
                    if (account.accountType == 'REVENUE') accIcon = Icons.trending_up;

                    return Card(
                      key: ValueKey(account.id),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.drag_handle, color: Colors.grey),
                        title: Row(
                          children:[
                            Icon(accIcon, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        subtitle: Text('${account.code} | ${account.currency}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            if (account.isSystem)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.lock, size: 16, color: Colors.grey),
                              ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primary),
                              onPressed: () => _showAccountDialog(existing: account),
                            ),
                            if (!account.isSystem) // زر الحذف يظهر فقط للحسابات العادية
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(AppStrings.warning),
                                        content: const Text('هل أنت متأكد من حذف هذا الحساب؟'),
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
                                  if (confirm == true) await dao.deleteAccount(account.id);
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
          ),
        ],
      ),
    );
  }
}