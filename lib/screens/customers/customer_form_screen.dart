import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/default_data.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/database.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerFormScreen({Key? key, required this.customerId}) : super(key: key);
  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  Customer? _existingCustomer;

  final _nameCtrl = TextEditingController();
  final _phone1Ctrl = TextEditingController();
  final _phone2Ctrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _neighborhoodCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();

  String _currency = 'SYP';
  String _gender = 'M';
  String _selectedCity = DefaultData.cities.first;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.customerId == 0) {
      setState(() => _isLoading = false);
      return;
    }
    final dao = ref.read(customersDaoProvider);
    final allCustomers = await dao.db.select(dao.db.customers).get();
    _existingCustomer = allCustomers.firstWhere((c) => c.id == widget.customerId);

    _nameCtrl.text = _existingCustomer!.name;
    _phone1Ctrl.text = _existingCustomer!.phone1 ?? '';
    _phone2Ctrl.text = _existingCustomer!.phone2 ?? '';
    _emailCtrl.text = _existingCustomer!.email ?? '';
    _neighborhoodCtrl.text = _existingCustomer!.neighborhood ?? '';
    _streetCtrl.text = _existingCustomer!.street ?? '';
    _notesCtrl.text = _existingCustomer!.notes ?? '';
    _currency = _existingCustomer!.currency;
    _gender = _existingCustomer!.gender;
    _selectedCity = _existingCustomer!.city ?? DefaultData.cities.first;

    setState(() => _isLoading = false);
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    final dao = ref.read(customersDaoProvider);

    // التحقق من تكرار الاسم
    final nameExists = await dao.isNameExists(_nameCtrl.text.trim(), widget.customerId);
    if (nameExists && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.nameAlreadyExists), backgroundColor: Colors.red));
      return; // توقف ولا تغلق الشاشة
    }

    final companion = CustomersCompanion(
      id: widget.customerId == 0 ? const drift.Value.absent() : drift.Value(widget.customerId),
      name: drift.Value(_nameCtrl.text.trim()),
      gender: drift.Value(_gender),
      currency: drift.Value(_currency),
      city: drift.Value(_selectedCity),
      neighborhood: drift.Value(_neighborhoodCtrl.text.trim()),
      street: drift.Value(_streetCtrl.text.trim()),
      phone1: drift.Value(_phone1Ctrl.text.trim()),
      phone2: drift.Value(_phone2Ctrl.text.trim()),
      email: drift.Value(_emailCtrl.text.trim()),
      notes: drift.Value(_notesCtrl.text.trim()),
      accountCode: widget.customerId == 0 ? const drift.Value.absent() : drift.Value(_existingCustomer!.accountCode),
    );

    await dao.saveCustomer(companion, isNew: widget.customerId == 0);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
      context.pop();
    }
  }

  // أداة ذكية للاقتراحات (Autocomplete)
  // تحديث الأداة لتأخذ اسم المدينة
  Widget _buildAutocompleteField(String label, TextEditingController controller, String fieldName, bool isMandatory) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
        // إرسال المدينة الحالية (_selectedCity) للدالة
        return await ref.read(customersDaoProvider).getSuggestions(fieldName, textEditingValue.text, _selectedCity);
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label, hintText: 'ابحث أو اكتب جديداً...'),
          validator: (v) => isMandatory && v!.trim().isEmpty ? AppStrings.fieldRequired : null,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: options.map((String option) => ListTile(title: Text(option), onTap: () => onSelected(option))).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(widget.customerId == 0 ? AppStrings.newCustomer : 'تعديل بيانات الزبون')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children:[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: AppStrings.customerName),
                      validator: (v) => v!.isEmpty ? AppStrings.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.gender, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const[
                        ButtonSegment(value: 'M', label: Text(AppStrings.male)),
                        ButtonSegment(value: 'F', label: Text(AppStrings.female)),
                      ],
                      selected: {_gender},
                      onSelectionChanged: (set) => setState(() => _gender = set.first),
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.currency, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const[
                        ButtonSegment(value: 'SYP', label: Text('ليرة سورية')),
                        ButtonSegment(value: 'USD', label: Text('دولار \$')),
                      ],
                      selected: {_currency},
                      onSelectionChanged: (set) => setState(() => _currency = set.first),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text('معلومات العنوان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(labelText: AppStrings.city),
                      items: DefaultData.cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                      onChanged: (val) => setState(() => _selectedCity = val!),
                    ),
                    const SizedBox(height: 12),
                    _buildAutocompleteField(AppStrings.neighborhood, _neighborhoodCtrl, 'neighborhood', true),
                    const SizedBox(height: 12),
                    _buildAutocompleteField(AppStrings.street, _streetCtrl, 'street', false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text('معلومات الاتصال', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),
                    TextFormField(controller: _phone1Ctrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: AppStrings.phone1)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _phone2Ctrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: AppStrings.phone2)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: AppStrings.email)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _notesCtrl, maxLines: 2, decoration: const InputDecoration(labelText: AppStrings.notes)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(onPressed: _saveCustomer, child: const Text(AppStrings.save)),
      ),
    );
  }
}