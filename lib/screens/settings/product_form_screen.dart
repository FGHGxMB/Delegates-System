import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/catalog_dao.dart';
import '../../database/database.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final int productId;

  const ProductFormScreen({Key? key, required this.categoryId, required this.productId}) : super(key: key);

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  Product? _existingProduct;

  // المعلومات الأساسية
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _currency = 'SYP';

  // الوحدة الأولى
  final _u1NameCtrl = TextEditingController();
  final _u1BarcodeCtrl = TextEditingController(); // [جديد]
  final _u1RetailCtrl = TextEditingController();
  final _u1WholesaleCtrl = TextEditingController();

  // الوحدة الثانية
  bool _hasUnit2 = false;
  final _u2NameCtrl = TextEditingController();
  final _u2BarcodeCtrl = TextEditingController(); // [جديد]
  final _u2FactorCtrl = TextEditingController();
  final _u2RetailCtrl = TextEditingController();
  final _u2WholesaleCtrl = TextEditingController();

  // الوحدة الثالثة
  bool _hasUnit3 = false;
  final _u3NameCtrl = TextEditingController();
  final _u3BarcodeCtrl = TextEditingController(); // [جديد]
  final _u3FactorCtrl = TextEditingController();
  final _u3RetailCtrl = TextEditingController();
  final _u3WholesaleCtrl = TextEditingController();

  int _defaultUnit = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.productId == 0) {
      setState(() => _isLoading = false);
      return;
    }

    final dao = ref.read(catalogDaoProvider);
    _existingProduct = await dao.getProductById(widget.productId);

    if (_existingProduct != null) {
      final p = _existingProduct!;
      _codeCtrl.text = p.code;
      _nameCtrl.text = p.name;
      _currency = p.currency;

      _u1NameCtrl.text = p.unit1Name;
      _u1BarcodeCtrl.text = p.unit1Barcode ?? '';
      _u1RetailCtrl.text = p.unit1PriceRetail.toString();
      _u1WholesaleCtrl.text = p.unit1PriceWholesale.toString();

      if (p.unit2Name != null) {
        _hasUnit2 = true;
        _u2NameCtrl.text = p.unit2Name!;
        _u2BarcodeCtrl.text = p.unit2Barcode ?? '';
        _u2FactorCtrl.text = p.unit2Factor.toString();
        _u2RetailCtrl.text = p.unit2PriceRetail.toString();
        _u2WholesaleCtrl.text = p.unit2PriceWholesale.toString();
      }

      if (p.unit3Name != null) {
        _hasUnit3 = true;
        _u3NameCtrl.text = p.unit3Name!;
        _u3BarcodeCtrl.text = p.unit3Barcode ?? '';
        _u3FactorCtrl.text = p.unit3Factor.toString();
        _u3RetailCtrl.text = p.unit3PriceRetail.toString();
        _u3WholesaleCtrl.text = p.unit3PriceWholesale.toString();
      }

      _defaultUnit = p.defaultUnit;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(catalogDaoProvider);

    // [جديد] التحقق من التكرار
    final exists = await dao.isProductCodeOrNameExists(_codeCtrl.text.trim(), _nameCtrl.text.trim(), widget.productId);
    if (exists && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.nameOrCodeExists), backgroundColor: Colors.red));
      return;
    }

    final companion = ProductsCompanion(
      categoryId: drift.Value(widget.categoryId),
      code: drift.Value(_codeCtrl.text.trim()),
      name: drift.Value(_nameCtrl.text.trim()),
      currency: drift.Value(_currency),
      defaultUnit: drift.Value(_defaultUnit),
      isActive: const drift.Value(true),

      // الوحدة الأولى
      unit1Name: drift.Value(_u1NameCtrl.text.trim()),
      unit1Barcode: drift.Value(_u1BarcodeCtrl.text.trim().isEmpty ? null : _u1BarcodeCtrl.text.trim()),
      unit1PriceRetail: drift.Value(double.parse(_u1RetailCtrl.text)),
      unit1PriceWholesale: drift.Value(double.parse(_u1WholesaleCtrl.text)),

      // الوحدة الثانية
      unit2Name: drift.Value(_hasUnit2 ? _u2NameCtrl.text.trim() : null),
      unit2Barcode: drift.Value(_hasUnit2 && _u2BarcodeCtrl.text.trim().isNotEmpty ? _u2BarcodeCtrl.text.trim() : null),
      unit2Factor: drift.Value(_hasUnit2 ? double.parse(_u2FactorCtrl.text) : null),
      unit2PriceRetail: drift.Value(_hasUnit2 ? double.parse(_u2RetailCtrl.text) : null),
      unit2PriceWholesale: drift.Value(_hasUnit2 ? double.parse(_u2WholesaleCtrl.text) : null),

      // الوحدة الثالثة
      unit3Name: drift.Value(_hasUnit3 && _hasUnit2 ? _u3NameCtrl.text.trim() : null),
      unit3Barcode: drift.Value(_hasUnit3 && _hasUnit2 && _u3BarcodeCtrl.text.trim().isNotEmpty ? _u3BarcodeCtrl.text.trim() : null),
      unit3Factor: drift.Value(_hasUnit3 && _hasUnit2 ? double.parse(_u3FactorCtrl.text) : null),
      unit3PriceRetail: drift.Value(_hasUnit3 && _hasUnit2 ? double.parse(_u3RetailCtrl.text) : null),
      unit3PriceWholesale: drift.Value(_hasUnit3 && _hasUnit2 ? double.parse(_u3WholesaleCtrl.text) : null),
    );

    try {
      if (widget.productId == 0) {
        final existingProducts = await dao.watchProductsByCategory(widget.categoryId).first;
        final newCompanion = companion.copyWith(displayOrder: drift.Value(existingProducts.length));
        await dao.insertProduct(newCompanion);
      } else {
        final updatedProduct = _existingProduct!.copyWith(
          code: companion.code.value,
          name: companion.name.value,
          currency: companion.currency.value,
          defaultUnit: companion.defaultUnit.value,
          unit1Name: companion.unit1Name.value,
          unit1Barcode: drift.Value(companion.unit1Barcode.value),
          unit1PriceRetail: companion.unit1PriceRetail.value,
          unit1PriceWholesale: companion.unit1PriceWholesale.value,
          unit2Name: drift.Value(companion.unit2Name.value),
          unit2Barcode: drift.Value(companion.unit2Barcode.value),
          unit2Factor: drift.Value(companion.unit2Factor.value),
          unit2PriceRetail: drift.Value(companion.unit2PriceRetail.value),
          unit2PriceWholesale: drift.Value(companion.unit2PriceWholesale.value),
          unit3Name: drift.Value(companion.unit3Name.value),
          unit3Barcode: drift.Value(companion.unit3Barcode.value),
          unit3Factor: drift.Value(companion.unit3Factor.value),
          unit3PriceRetail: drift.Value(companion.unit3PriceRetail.value),
          unit3PriceWholesale: drift.Value(companion.unit3PriceWholesale.value),
        );
        await dao.updateProductDetails(updatedProduct);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: قد يكون الرمز مكرراً.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == 0 ? AppStrings.newProduct : AppStrings.editProduct),
        backgroundColor: Colors.red[800],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children:[
            // ─── المعلومات الأساسية ───
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text(AppStrings.basicInfo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                    const Divider(),
                    TextFormField(
                      controller: _codeCtrl,
                      decoration: const InputDecoration(labelText: AppStrings.productCode),
                      validator: (v) => v!.isEmpty ? AppStrings.fieldRequired : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: AppStrings.productName),
                      validator: (v) => v!.isEmpty ? AppStrings.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(AppStrings.productCurrency, style: TextStyle(fontWeight: FontWeight.bold)),
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

            // ─── الوحدة الأولى (إجبارية) ───
            _buildUnitCard(
              title: AppStrings.unit1,
              nameCtrl: _u1NameCtrl,
              barcodeCtrl: _u1BarcodeCtrl,
              retailCtrl: _u1RetailCtrl,
              wholesaleCtrl: _u1WholesaleCtrl,
              isMandatory: true,
            ),
            const SizedBox(height: 16),

            // ─── الوحدة الثانية (اختيارية) ───
            Card(
              child: Column(
                children:[
                  SwitchListTile(
                    title: const Text(AppStrings.enableUnit2, style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _hasUnit2,
                    onChanged: (val) {
                      setState(() {
                        _hasUnit2 = val;
                        if (!val) {
                          _hasUnit3 = false;
                          if (_defaultUnit > 1) _defaultUnit = 1;
                        }
                      });
                    },
                  ),
                  if (_hasUnit2)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildUnitFields(
                        nameCtrl: _u2NameCtrl,
                        barcodeCtrl: _u2BarcodeCtrl,
                        retailCtrl: _u2RetailCtrl,
                        wholesaleCtrl: _u2WholesaleCtrl,
                        factorCtrl: _u2FactorCtrl,
                        factorHint: AppStrings.conversionFactor2,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── الوحدة الثالثة (اختيارية) ───
            if (_hasUnit2)
              Card(
                child: Column(
                  children:[
                    SwitchListTile(
                      title: const Text(AppStrings.enableUnit3, style: TextStyle(fontWeight: FontWeight.bold)),
                      value: _hasUnit3,
                      onChanged: (val) {
                        setState(() {
                          _hasUnit3 = val;
                          if (!val && _defaultUnit == 3) _defaultUnit = 2;
                        });
                      },
                    ),
                    if (_hasUnit3)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildUnitFields(
                          nameCtrl: _u3NameCtrl,
                          barcodeCtrl: _u3BarcodeCtrl,
                          retailCtrl: _u3RetailCtrl,
                          wholesaleCtrl: _u3WholesaleCtrl,
                          factorCtrl: _u3FactorCtrl,
                          factorHint: AppStrings.conversionFactor3,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // ─── الوحدة الافتراضية ───
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text(AppStrings.defaultUnit, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments:[
                        const ButtonSegment(value: 1, label: Text('الأولى')),
                        if (_hasUnit2) const ButtonSegment(value: 2, label: Text('الثانية')),
                        if (_hasUnit3) const ButtonSegment(value: 3, label: Text('الثالثة')),
                      ],
                      selected: {_defaultUnit},
                      onSelectionChanged: (set) => setState(() => _defaultUnit = set.first),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red[800]),
          onPressed: _saveProduct,
          child: const Text(AppStrings.save),
        ),
      ),
    );
  }

  Widget _buildUnitCard({
    required String title,
    required TextEditingController nameCtrl,
    required TextEditingController barcodeCtrl,
    required TextEditingController retailCtrl,
    required TextEditingController wholesaleCtrl,
    bool isMandatory = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
            const Divider(),
            _buildUnitFields(
                nameCtrl: nameCtrl,
                barcodeCtrl: barcodeCtrl,
                retailCtrl: retailCtrl,
                wholesaleCtrl: wholesaleCtrl,
                isMandatory: isMandatory
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitFields({
    required TextEditingController nameCtrl,
    required TextEditingController barcodeCtrl,
    required TextEditingController retailCtrl,
    required TextEditingController wholesaleCtrl,
    TextEditingController? factorCtrl,
    String? factorHint,
    bool isMandatory = true,
  }) {
    return Column(
      children:[
        TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'اسم الوحدة (مثال: قطعة، علبة)'),
          validator: (v) => isMandatory && v!.isEmpty ? AppStrings.fieldRequired : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: barcodeCtrl,
          decoration: InputDecoration(
            labelText: 'باركود هذه الوحدة',
            suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سيتم تفعيل الكاميرا لاحقاً')));
                }
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (factorCtrl != null) ...[
          TextFormField(
            controller: factorCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: factorHint),
            validator: (v) => isMandatory && v!.isEmpty ? AppStrings.fieldRequired : null,
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children:[
            Expanded(
              child: TextFormField(
                controller: retailCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: AppStrings.priceRetail),
                validator: (v) => isMandatory && v!.isEmpty ? AppStrings.fieldRequired : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: wholesaleCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: AppStrings.priceWholesale),
                validator: (v) => isMandatory && v!.isEmpty ? AppStrings.fieldRequired : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}