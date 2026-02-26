import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/default_data.dart'; // [أضفنا الاستيراد]
import '../../widgets/password_dialog.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/daos/warehouses_dao.dart';
import '../../database/daos/customers_dao.dart'; // [أضفنا الاستيراد]
import '../../database/database.dart';

class ProtectedSettingsScreen extends ConsumerStatefulWidget {
  const ProtectedSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProtectedSettingsScreen> createState() => _ProtectedSettingsScreenState();
}

class _ProtectedSettingsScreenState extends ConsumerState<ProtectedSettingsScreen> {
  final _delegatePasswordController = TextEditingController();
  final _mainAccountPrefixCtrl = TextEditingController(); // [جديد] للرمز الرئيسي
  bool _obscurePassword = true;
  bool _isLoading = true;

  String? _selectedDefaultWarehouse;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dao = ref.read(settingsDaoProvider);
    _delegatePasswordController.text = await dao.getValue('custom_delegate_password') ?? '';
    _selectedDefaultWarehouse = await dao.getValue('default_warehouse_name');

    // تحميل الرمز الرئيسي للزبائن ووضعه في الحقل
    _mainAccountPrefixCtrl.text = await dao.getValue('main_account_prefix') ?? DefaultData.defaultMainAccountPrefix;

    setState(() => _isLoading = false);
  }

  Future<void> _saveChanges() async {
    final isAuthorized = await showPasswordDialog(context);

    if (isAuthorized && mounted) {
      final dao = ref.read(settingsDaoProvider);

      await dao.setValue('custom_delegate_password', _delegatePasswordController.text.trim());

      if (_selectedDefaultWarehouse != null) {
        await dao.setValue('default_warehouse_name', _selectedDefaultWarehouse!);
      }

      // حفظ الرمز الرئيسي للزبائن وتحديث جميع الزبائن ليصبحوا "مُعدَّلين"
      final oldPrefix = await dao.getValue('main_account_prefix') ?? DefaultData.defaultMainAccountPrefix;
      final newPrefix = _mainAccountPrefixCtrl.text.trim();

      await dao.setValue('main_account_prefix', newPrefix);

      if (oldPrefix != newPrefix) {
        await ref.read(customersDaoProvider).markAllAsModified();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final warehousesStream = ref.watch(warehousesDaoProvider).watchAllWarehouses();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.protectedSettings),
        backgroundColor: Colors.red[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:[
          // 1. صلاحية المندوب
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text(AppStrings.delegatePassword, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _delegatePasswordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: AppStrings.delegatePasswordHint,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. اختيار المستودع الافتراضي
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text(AppStrings.defaultWarehouse, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Warehouse>>(
                      stream: warehousesStream,
                      builder: (context, snapshot) {
                        final warehouses = snapshot.data ?? [];
                        if (warehouses.isNotEmpty && _selectedDefaultWarehouse != null) {
                          final exists = warehouses.any((w) => w.name == _selectedDefaultWarehouse);
                          if (!exists) _selectedDefaultWarehouse = null;
                        }

                        return DropdownButtonFormField<String>(
                          value: _selectedDefaultWarehouse,
                          hint: const Text('اختر مستودعاً'),
                          items: warehouses.map((w) {
                            return DropdownMenuItem(value: w.name, child: Text(w.name));
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedDefaultWarehouse = val),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. رمز الحساب الرئيسي (مُصحح)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text(AppStrings.mainAccountPrefix, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mainAccountPrefixCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'مثال: 12101'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. أزرار الإدارة الفرعية
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: const Icon(Icons.store, color: Colors.blue),
            title: const Text('إدارة المستودعات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/manage_warehouses'),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: const Icon(Icons.category, color: Colors.green),
            title: const Text('إدارة المجموعات والمواد'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/manage_categories'),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: const Icon(Icons.account_balance_wallet, color: Colors.orange),
            title: const Text('إدارة الحسابات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/manage_accounts'),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children:[
            Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text(AppStrings.cancel))),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red[800]),
                onPressed: _saveChanges,
                child: const Text(AppStrings.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}