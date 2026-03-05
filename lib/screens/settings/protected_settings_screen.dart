import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/default_data.dart';
import '../../widgets/password_dialog.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/daos/warehouses_dao.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/database.dart';

class ProtectedSettingsScreen extends ConsumerStatefulWidget {
  const ProtectedSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProtectedSettingsScreen> createState() => _ProtectedSettingsScreenState();
}

class _ProtectedSettingsScreenState extends ConsumerState<ProtectedSettingsScreen> {
  // --- Controllers ---
  final _delegateNameCtrl = TextEditingController();
  final _costCenterCodeCtrl = TextEditingController();
  final _sypBoxCodeCtrl = TextEditingController();
  final _usdBoxCodeCtrl = TextEditingController();

  final _mainAccountPrefixCtrl = TextEditingController();
  final _countryNameCtrl = TextEditingController();
  final _customerCodePrefixCtrl = TextEditingController();
  final _customerNamePrefixCtrl = TextEditingController();

  final _delegatePasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = true;
  String? _selectedDefaultWarehouseCode;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dao = ref.read(settingsDaoProvider);

    // بيانات المندوب
    _delegateNameCtrl.text = await dao.getValue('delegate_name') ?? '';
    _costCenterCodeCtrl.text = await dao.getValue('delegate_cost_center_code') ?? '';
    _sypBoxCodeCtrl.text = await dao.getValue('delegate_syp_box_code') ?? '';
    _usdBoxCodeCtrl.text = await dao.getValue('delegate_usd_box_code') ?? '';

    // بيانات الزبائن
    _mainAccountPrefixCtrl.text = await dao.getValue('main_account_prefix') ?? DefaultData.defaultMainAccountPrefix;
    _countryNameCtrl.text = await dao.getValue('country_name') ?? '';
    _customerCodePrefixCtrl.text = await dao.getValue('customer_account_code_prefix') ?? '';
    _customerNamePrefixCtrl.text = await dao.getValue('customer_account_name_prefix') ?? '';

    // إعدادات النظام
    _delegatePasswordController.text = await dao.getValue('custom_delegate_password') ?? '';
    _selectedDefaultWarehouseCode = await dao.getValue('default_warehouse_code');

    setState(() => _isLoading = false);
  }

  Future<void> _saveChanges() async {
    final isAuthorized = await showPasswordDialog(context);

    if (isAuthorized && mounted) {
      final dao = ref.read(settingsDaoProvider);

      // حفظ بيانات المندوب
      await dao.setValue('delegate_name', _delegateNameCtrl.text.trim());
      await dao.setValue('delegate_cost_center_code', _costCenterCodeCtrl.text.trim());
      await dao.setValue('delegate_syp_box_code', _sypBoxCodeCtrl.text.trim());
      await dao.setValue('delegate_usd_box_code', _usdBoxCodeCtrl.text.trim());

      // حفظ بيانات الزبائن
      final oldPrefix = await dao.getValue('main_account_prefix') ?? DefaultData.defaultMainAccountPrefix;
      final newPrefix = _mainAccountPrefixCtrl.text.trim();

      await dao.setValue('main_account_prefix', newPrefix);
      await dao.setValue('country_name', _countryNameCtrl.text.trim());
      await dao.setValue('customer_account_code_prefix', _customerCodePrefixCtrl.text.trim());
      await dao.setValue('customer_account_name_prefix', _customerNamePrefixCtrl.text.trim());

      // حفظ إعدادات النظام
      await dao.setValue('custom_delegate_password', _delegatePasswordController.text.trim());
      if (_selectedDefaultWarehouseCode != null) {
        await dao.setValue('default_warehouse_code', _selectedDefaultWarehouseCode!);
      }

      // تحديث الزبائن في حال تغير الرمز الرئيسي
      if (oldPrefix != newPrefix) {
        await ref.read(customersDaoProvider).markAllAsModified();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
        context.pop();
      }
    }
  }

  // دالة مساعدة لرسم الحقول بشكل موحد وأنيق
  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final warehousesStream = ref.watch(warehousesDaoProvider).watchAllWarehouses();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.protectedSettings),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:[

          // 1. بطاقة بيانات المندوب
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children:[
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('بيانات المندوب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildTextField(_delegateNameCtrl, 'اسم المندوب', 'مثال: أحمد محمد'),
                  _buildTextField(_costCenterCodeCtrl, 'رمز مركز الكلفة', 'مثال: CC101', type: TextInputType.number),
                  _buildTextField(_sypBoxCodeCtrl, 'رمز صندوق الليرة السورية', 'مثال: 101', type: TextInputType.number),
                  _buildTextField(_usdBoxCodeCtrl, 'رمز صندوق الدولار', 'مثال: 102', type: TextInputType.number),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. بطاقة إعدادات الزبائن
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Row(
                    children:[
                      Icon(Icons.people, color: Colors.green),
                      SizedBox(width: 8),
                      Text('إعدادات حسابات الزبائن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildTextField(_mainAccountPrefixCtrl, AppStrings.mainAccountPrefix, 'مثال: 12101', type: TextInputType.number),
                  _buildTextField(_countryNameCtrl, 'اسم الدولة', 'مثال: سوريا'),
                  _buildTextField(_customerCodePrefixCtrl, 'بادئة رمز حساب الزبون', 'مثال: CUS-'),
                  _buildTextField(_customerNamePrefixCtrl, 'بادئة اسم حساب الزبون', 'مثال: زبون - '),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. بطاقة إعدادات النظام
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children:[
                      Icon(Icons.settings_applications, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('إعدادات النظام', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('المستودع الافتراضي', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Warehouse>>(
                      stream: warehousesStream,
                      builder: (context, snapshot) {
                        final warehouses = snapshot.data ??[];
                        if (warehouses.isNotEmpty && _selectedDefaultWarehouseCode != null) {
                          final exists = warehouses.any((w) => w.code == _selectedDefaultWarehouseCode);
                          if (!exists) _selectedDefaultWarehouseCode = null;
                        }

                        return DropdownButtonFormField<String>(
                          value: _selectedDefaultWarehouseCode,
                          hint: const Text('اختر مستودعاً'),
                          items: warehouses.map((w) {
                            // نعرض الاسم والرمز، ونحفظ الرمز
                            return DropdownMenuItem(value: w.code, child: Text('${w.name} (${w.code})'));
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedDefaultWarehouseCode = val),
                          decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        );
                      }
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _delegatePasswordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppStrings.delegatePassword,
                      hintText: AppStrings.delegatePasswordHint,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          const SizedBox(height: 24),
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
                style: FilledButton.styleFrom(backgroundColor: Colors.red[800], padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: _saveChanges,
                child: const Text(AppStrings.save, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}