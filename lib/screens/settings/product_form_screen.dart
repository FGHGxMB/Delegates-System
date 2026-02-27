import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/catalog_dao.dart';
import '../../database/database.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final int categoryId; // الآن هذا لن نعتمد عليه كلياً لأن المادة ترتبط بالعمود
  final int productId; // 0 يعني مادة جديدة

  const ProductFormScreen({Key? key, required this.categoryId, required this.productId}) : super(key: key);

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // القوائم المنسدلة المتسلسلة
  int? _selectedCategoryId;
  int? _selectedColumnId;
  List<ProductCategory> _categories =[];
  List<ProductColumn> _columnsForSelectedCategory =[];

  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _currency = 'SYP';
  bool _isActive = true;

  // الوحدة الأولى (إجبارية)
  final _u1NameCtrl = TextEditingController(text: 'قطعة');
  final _u1RetailCtrl = TextEditingController();
  final _u1WholesaleCtrl = TextEditingController();

  // الوحدة الثانية والثالثة (اختيارية)
  bool _hasUnit2 = false;
  final _u2NameCtrl = TextEditingController();
  final _u2FactorCtrl = TextEditingController();
  final _u2RetailCtrl = TextEditingController();
  final _u2WholesaleCtrl = TextEditingController();

  bool _hasUnit3 = false;
  final _u3NameCtrl = TextEditingController();
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
    final dao = ref.read(catalogDaoProvider);

    // 1. جلب كل المجموعات
    _categories = await dao.db.select(dao.db.productCategories).get();

    if (widget.productId != 0) {
      // تعديل مادة موجودة
      final product = await (dao.db.select(dao.db.products)..where((t) => t.id.equals(widget.productId))).getSingleOrNull();
      if (product != null) {
        _codeCtrl.text = product.code;
        _nameCtrl.text = product.name;
        _currency = product.currency;
        _isActive = product.isActive;
        _defaultUnit = product.defaultUnit;

        // تحديد العمود والمجموعة بذكاء
        _selectedColumnId = product.columnId;
        if (_selectedColumnId != null) {
          final column = await (dao.db.select(dao.db.productColumns)..where((t) => t.id.equals(_selectedColumnId!))).getSingleOrNull();
          if (column != null) {
            _selectedCategoryId = column.categoryId;
            _columnsForSelectedCategory = await dao.getColumnsByCategory(_selectedCategoryId!);
          }
        }

        // تعبئة بيانات الوحدات
        _u1NameCtrl.text = product.unit1Name;
        _u1RetailCtrl.text = product.unit1PriceRetail.toString();
        _u1WholesaleCtrl.text = product.unit1PriceWholesale.toString();

        if (product.unit2Name != null) {
          _hasUnit2 = true;
          _u2NameCtrl.text = product.unit2Name!;
          _u2FactorCtrl.text = product.unit2Factor.toString();
          _u2RetailCtrl.text = product.unit2PriceRetail.toString();
          _u2WholesaleCtrl.text = product.unit2PriceWholesale.toString();
        }
        if (product.unit3Name != null) {
          _hasUnit3 = true;
          _u3NameCtrl.text = product.unit3Name!;
          _u3FactorCtrl.text = product.unit3Factor.toString();
          _u3RetailCtrl.text = product.unit3PriceRetail.toString();
          _u3WholesaleCtrl.text = product.unit3PriceWholesale.toString();
        }
      }
    } else {
      // مادة جديدة: إذا كان هناك مجموعات، نختار الأولى تلقائياً ونجلب عواميدها
      if (_categories.isNotEmpty) {
        _selectedCategoryId = widget.categoryId > 0 ? widget.categoryId : _categories.first.id;
        await _loadColumnsForCategory(_selectedCategoryId!);
      }
    }

    setState(() => _isLoading = false);
  }

  // دالة تُستدعى عند تغيير المجموعة لجلب عواميدها
  Future<void> _loadColumnsForCategory(int categoryId) async {
    final dao = ref.read(catalogDaoProvider);
    final columns = await dao.getColumnsByCategory(categoryId);
    setState(() {
      _columnsForSelectedCategory = columns;
      // إذا كان هناك عواميد، اختر الأول تلقائياً، وإلا اجعله فارغاً
      _selectedColumnId = columns.isNotEmpty ? columns.first.id : null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // التحقق من تحديد العمود
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب اختيار المجموعة!'), backgroundColor: Colors.red));
      return;
    }
    if (_selectedColumnId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب اختيار العمود! إذا كانت القائمة فارغة، قم بإنشاء عمود في هذه المجموعة أولاً.'), backgroundColor: Colors.red));
      return;
    }

    final dao = ref.read(catalogDaoProvider);

    final companion = ProductsCompanion(
      id: widget.productId == 0 ? const drift.Value.absent() : drift.Value(widget.productId),
      code: drift.Value(_codeCtrl.text.trim()),
      categoryId: drift.Value(_selectedCategoryId!), // لحفظ التوافق
      columnId: drift.Value(_selectedColumnId!), // 👈 هذا هو الأهم الآن
      name: drift.Value(_nameCtrl.text.trim()),
      currency: drift.Value(_currency),
      isActive: drift.Value(_isActive),
      defaultUnit: drift.Value(_defaultUnit),

      unit1Name: drift.Value(_u1NameCtrl.text.trim()),
      unit1PriceRetail: drift.Value(double.parse(_u1RetailCtrl.text)),
      unit1PriceWholesale: drift.Value(double.parse(_u1WholesaleCtrl.text)),

      unit2Name: _hasUnit2 ? drift.Value(_u2NameCtrl.text.trim()) : const drift.Value.absent(),
      unit2Factor: _hasUnit2 ? drift.Value(double.parse(_u2FactorCtrl.text)) : const drift.Value.absent(),
      unit2PriceRetail: _hasUnit2 ? drift.Value(double.parse(_u2RetailCtrl.text)) : const drift.Value.absent(),
      unit2PriceWholesale: _hasUnit2 ? drift.Value(double.parse(_u2WholesaleCtrl.text)) : const drift.Value.absent(),

      unit3Name: (_hasUnit2 && _hasUnit3) ? drift.Value(_u3NameCtrl.text.trim()) : const drift.Value.absent(),
      unit3Factor: (_hasUnit2 && _hasUnit3) ? drift.Value(double.parse(_u3FactorCtrl.text)) : const drift.Value.absent(),
      unit3PriceRetail: (_hasUnit2 && _hasUnit3) ? drift.Value(double.parse(_u3RetailCtrl.text)) : const drift.Value.absent(),
      unit3PriceWholesale: (_hasUnit2 && _hasUnit3) ? drift.Value(double.parse(_u3WholesaleCtrl.text)) : const drift.Value.absent(),
    );

    try {
      if (widget.productId == 0) {
        await dao.db.into(dao.db.products).insert(companion);
      } else {
        await (dao.db.update(dao.db.products)..where((t) => t.id.equals(widget.productId))).write(companion);
      }
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في الحفظ: قد يكون رمز المادة مكرراً!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == 0 ? AppStrings.newProduct : AppStrings.edit),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children:[
            // ─── القسم الأول: تصنيف المادة (مجموعة ثم عمود) ───
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Text('تصنيف المادة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                    const SizedBox(height: 12),

                    // 1. قائمة المجموعات
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'اختر المجموعة', border: OutlineInputBorder()),
                      items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                      validator: (val) => val == null ? AppStrings.fieldRequired : null,
                      onChanged: (val) {
                        if (val != null && val != _selectedCategoryId) {
                          setState(() => _selectedCategoryId = val);
                          _loadColumnsForCategory(val); // جلب العواميد فوراً
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. قائمة العواميد (تعتمد على المجموعة)
                    DropdownButtonFormField<int>(
                      value: _selectedColumnId,
                      decoration: InputDecoration(
                        labelText: 'اختر العمود',
                        border: const OutlineInputBorder(),
                        // تلوين الحقل بالأحمر إذا لم يكن هناك عواميد للتنبيه
                        fillColor: _columnsForSelectedCategory.isEmpty && _selectedCategoryId != null ? Colors.red.shade50 : null,
                        filled: _columnsForSelectedCategory.isEmpty && _selectedCategoryId != null,
                      ),
                      items: _columnsForSelectedCategory.map((col) => DropdownMenuItem(value: col.id, child: Text(col.name))).toList(),
                      validator: (val) => val == null ? 'يجب اختيار العمود' : null,
                      onChanged: (val) => setState(() => _selectedColumnId = val),
                      hint: Text(_columnsForSelectedCategory.isEmpty ? 'لا يوجد عواميد في هذه المجموعة!' : 'اختر العمود'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── القسم الثاني: بيانات المادة الأساسية ───
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children:[
                    Row(
                      children:[
                        Expanded(child: TextFormField(controller: _codeCtrl, decoration: const InputDecoration(labelText: AppStrings.productCode, border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? AppStrings.fieldRequired : null)),
                        const SizedBox(width: 8),
                        Expanded(flex: 2, child: TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: AppStrings.productName, border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? AppStrings.fieldRequired : null)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children:[
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _currency,
                            decoration: const InputDecoration(labelText: 'عملة المادة', border: OutlineInputBorder()),
                            items: const[DropdownMenuItem(value: 'SYP', child: Text('ليرة سورية')), DropdownMenuItem(value: 'USD', child: Text('دولار أمريكي'))],
                            onChanged: (val) => setState(() => _currency = val!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children:[
                            const Text('حالة المادة:'),
                            Switch(value: _isActive, onChanged: (val) => setState(() => _isActive = val), activeColor: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── القسم الثالث: الوحدات والأسعار ───
            _buildUnitCard(1, 'الوحدة الأساسية (إجبارية)', _u1NameCtrl, null, _u1RetailCtrl, _u1WholesaleCtrl),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text(AppStrings.addUnit2),
              value: _hasUnit2,
              onChanged: (v) => setState(() { _hasUnit2 = v; if (!v) _hasUnit3 = false; if(_defaultUnit > 1 && !v) _defaultUnit = 1; }),
            ),
            if (_hasUnit2) _buildUnitCard(2, 'الوحدة الثانية', _u2NameCtrl, _u2FactorCtrl, _u2RetailCtrl, _u2WholesaleCtrl),

            if (_hasUnit2)
              SwitchListTile(
                title: const Text(AppStrings.addUnit3),
                value: _hasUnit3,
                onChanged: (v) => setState(() { _hasUnit3 = v; if(_defaultUnit > 2 && !v) _defaultUnit = 2; }),
              ),
            if (_hasUnit3) _buildUnitCard(3, 'الوحدة الثالثة', _u3NameCtrl, _u3FactorCtrl, _u3RetailCtrl, _u3WholesaleCtrl),

            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text(AppStrings.save, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard(int unitNum, String title, TextEditingController nameCtrl, TextEditingController? factorCtrl, TextEditingController rCtrl, TextEditingController wCtrl) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.blue.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                Row(
                  children:[
                    const Text('افتراضية', style: TextStyle(fontSize: 12)),
                    Radio<int>(value: unitNum, groupValue: _defaultUnit, onChanged: (v) => setState(() => _defaultUnit = v!)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children:[
                Expanded(child: TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الوحدة', isDense: true, border: OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? '*' : null)),
                if (factorCtrl != null) ...[
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: factorCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'تساوي كم ${unitNum==2? _u1NameCtrl.text : _u2NameCtrl.text}', isDense: true, border: const OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? '*' : null)),
                ]
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children:[
                Expanded(child: TextFormField(controller: rCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعر المستهلك', isDense: true, border: OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? '*' : null)),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: wCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعر المحل', isDense: true, border: OutlineInputBorder(), filled: true, fillColor: Colors.white), validator: (v) => v!.isEmpty ? '*' : null)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}