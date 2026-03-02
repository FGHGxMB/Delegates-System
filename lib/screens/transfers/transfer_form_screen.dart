import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/transfers_dao.dart';
import '../../database/database.dart';
import '../../providers/database_provider.dart';
import '../../utils/currency_utils.dart';
import '../invoices/product_selection_screen.dart';

// كلاس مساعد لواجهة أقلام المناقلة
class TransferLineUI {
  final Product product;
  int unitNumber;
  String unitName;
  double quantity;

  TransferLineUI({required this.product, required this.unitNumber, required this.unitName, required this.quantity});
}

class TransferFormScreen extends ConsumerStatefulWidget {
  final int transferId; // 0 تعني جديدة
  const TransferFormScreen({Key? key, required this.transferId}) : super(key: key);

  @override
  ConsumerState<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends ConsumerState<TransferFormScreen> {
  bool _isLoading = true;
  bool _canPopScope = false;

  String _status = 'DRAFT';
  DateTime _date = DateTime.now();
  String _name = '';

  int? _senderWarehouseId;
  int? _receiverWarehouseId;
  final _noteCtrl = TextEditingController();

  List<TransferLineUI> _lines = [];
  List<Warehouse> _warehouses =[];

  @override
  void initState() {
    super.initState();
    _generateAutoName();
    _loadData();
  }

  // توليد الاسم التلقائي بنظام 12 ساعة (صباحاً/مساءً)
  void _generateAutoName() {
    if (widget.transferId == 0) {
      final days =['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      final dayName = days[_date.weekday - 1];

      int hour = _date.hour;
      String period = hour >= 12 ? 'مساءً' : 'صباحاً';
      hour = hour % 12;
      if (hour == 0) hour = 12; // الساعة 0 (منتصف الليل) أو 12 ظهراً

      _name = 'مناقلة $dayName ${_date.day}/${_date.month}/${_date.year} $hour:${_date.minute.toString().padLeft(2, '0')} $period';
    }
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    _warehouses = await db.select(db.warehouses).get();

    if (widget.transferId != 0) {
      final tDao = ref.read(transfersDaoProvider);
      final data = await tDao.getTransferWithLines(widget.transferId);
      if (data != null) {
        _status = data.transfer.status;
        _name = data.transfer.name;
        _date = DateTime.parse(data.transfer.date);

        // ملاحظة: تأكد أن هذه الأسماء مطابقة لجدولك (senderWarehouseId / receiverWarehouseId / note)
        // إذا كان هناك خطأ هنا، غيرها حسب جدولك في tables.dart
        _senderWarehouseId = data.transfer.fromWarehouse as int?;
        _receiverWarehouseId = data.transfer.toWarehouse as int?;
        _noteCtrl.text = data.transfer.note ?? '';

        final products = await db.select(db.products).get();
        _lines = data.lines.map((l) {
          final p = products.firstWhere((prod) => prod.id == l.productId);
          return TransferLineUI(
            product: p,
            unitNumber: l.unitNumber,
            unitName: l.unitName ?? '',
            quantity: l.quantity,
          );
        }).toList();
      }
    }

    if (_status == 'SENT') _canPopScope = true;
    setState(() => _isLoading = false);
  }

  bool get _isReadOnly => _status == 'SENT';

  Future<void> _addProducts() async {
    final selectedProducts = await Navigator.push<List<Product>>(
      context,
      MaterialPageRoute(builder: (_) => const ProductSelectionScreen(isSingleSelection: false)),
    );

    if (selectedProducts != null && selectedProducts.isNotEmpty && mounted) {
      setState(() {
        for (var p in selectedProducts) {
          int unit = p.defaultUnit;
          String unitName = unit == 1 ? p.unit1Name : unit == 2 ? p.unit2Name! : p.unit3Name!;
          _lines.add(TransferLineUI(product: p, unitNumber: unit, unitName: unitName, quantity: 1.0));
        }
      });
    }
  }

  // 🔴 الإضافة الجديدة: دالة تعديل الوحدة
  Future<void> _editUnit(TransferLineUI line) async {
    if (_isReadOnly) return;
    int selected = line.unitNumber;
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('تغيير الوحدة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                RadioListTile<int>(title: Text(line.product.unit1Name), value: 1, groupValue: selected, onChanged: (v){ selected = v!; Navigator.pop(ctx); }),
                if (line.product.unit2Name != null) RadioListTile<int>(title: Text(line.product.unit2Name!), value: 2, groupValue: selected, onChanged: (v){ selected = v!; Navigator.pop(ctx); }),
                if (line.product.unit3Name != null) RadioListTile<int>(title: Text(line.product.unit3Name!), value: 3, groupValue: selected, onChanged: (v){ selected = v!; Navigator.pop(ctx); }),
              ],
            )
        )
    );

    setState(() {
      if (line.unitNumber != selected) {
        line.unitNumber = selected;
        line.unitName = selected == 1 ? line.product.unit1Name : selected == 2 ? line.product.unit2Name! : line.product.unit3Name!;
      }
    });
  }

  Future<void> _editQuantity(TransferLineUI line) async {
    if (_isReadOnly) return;
    final ctrl = TextEditingController(text: CurrencyUtils.format(line.quantity));
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('تعديل الكمية'),
          content: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: InputDecoration(suffixText: line.unitName),
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
            FilledButton(
              onPressed: () {
                final val = CurrencyUtils.parse(ctrl.text);
                if (val > 0) setState(() => line.quantity = val);
                Navigator.pop(ctx);
              },
              child: const Text(AppStrings.save),
            )
          ],
        )
    );
  }

  void _confirmDeleteTransfer() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحذير الحذف', style: TextStyle(color: Colors.red)),
        content: const Text('هل أنت متأكد من حذف هذه المناقلة نهائياً؟'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(transfersDaoProvider).deleteTransfer(widget.transferId);
              if (mounted) {
                setState(() => _canPopScope = true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف')));
                context.pop();
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTransfer({bool issue = false}) async {
    if (_senderWarehouseId == null || _receiverWarehouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تحديد المستودع المُرسِل والمُستقبِل'), backgroundColor: Colors.red));
      return;
    }
    if (_senderWarehouseId == _receiverWarehouseId) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن النقل لنفس المستودع!'), backgroundColor: Colors.red));
      return;
    }
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن حفظ مناقلة فارغة من المواد'), backgroundColor: Colors.red));
      return;
    }

    String newStatus = issue ? 'ISSUED' : _status;

    final companion = TransfersCompanion(
      id: widget.transferId == 0 ? const drift.Value.absent() : drift.Value(widget.transferId),
      name: drift.Value(_name),
      status: drift.Value(newStatus),
      date: drift.Value('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
      fromWarehouse: drift.Value(_senderWarehouseId! as String?),
      toWarehouse: drift.Value(_receiverWarehouseId! as String?),
      note: drift.Value(_noteCtrl.text.trim()),
    );

    final linesCompanion = _lines.map((l) => TransferLinesCompanion(
      productId: drift.Value(l.product.id),
      productCode: drift.Value(l.product.code),
      productName: drift.Value(l.product.name),
      unitNumber: drift.Value(l.unitNumber),
      unitName: drift.Value(l.unitName),
      quantity: drift.Value(l.quantity),
    )).toList();

    // 🔴 الإضافة الجديدة: إحاطة الحفظ بـ Try/Catch لمعرفة الخطأ إن وجد
    try {
      await ref.read(transfersDaoProvider).saveTransfer(companion, linesCompanion);

      if (mounted) {
        setState(() => _canPopScope = true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(issue ? 'تم تخريج المناقلة' : 'تم الحفظ')));
        context.pop();
      }
    } catch (e) {
      // 🚨 إذا فشل الحفظ، ستظهر هذه الرسالة الحمراء لتدلنا على اسم الحقل الناقص!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('حدث خطأ أثناء الحفظ! التفاصيل: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return PopScope(
      canPop: _canPopScope,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('تأكيد الخروج', style: TextStyle(color: Colors.red)),
            content: const Text('سيتم فقدان أي تغييرات لم تُحفظ.'),
            actions:[
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('البقاء')),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(ctx, true), child: const Text('خروج')),
            ],
          ),
        ) ?? false;
        if (shouldPop && mounted) {
          setState(() => _canPopScope = true);
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بطاقة مناقلة', style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions:[
            if (widget.transferId != 0 && _status != 'SENT')
              IconButton(icon: const Icon(Icons.delete), tooltip: 'حذف المناقلة', onPressed: _confirmDeleteTransfer),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Chip(
                  label: Text(_status == 'DRAFT' ? 'مسودة' : _status == 'ISSUED' ? 'مُخرجة' : 'مُرسلة', style: const TextStyle(color: Colors.white, fontSize: 10)),
                  backgroundColor: _status == 'DRAFT' ? AppColors.draftColor : _status == 'ISSUED' ? AppColors.issuedColor : AppColors.sentColor,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children:[
            // ─── رأس المناقلة ───
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children:[
                  Text(_name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children:[
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _senderWarehouseId,
                          decoration: const InputDecoration(labelText: 'مستودع مُرسِل (مِن)', border: OutlineInputBorder(), isDense: true),
                          items: _warehouses.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                          onChanged: _isReadOnly ? null : (val) => setState(() => _senderWarehouseId = val),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward, color: Colors.grey)),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _receiverWarehouseId,
                          decoration: const InputDecoration(labelText: 'مستودع مُستقبِل (إلى)', border: OutlineInputBorder(), isDense: true),
                          items: _warehouses.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                          onChanged: _isReadOnly ? null : (val) => setState(() => _receiverWarehouseId = val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── جدول المواد ───
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Row(
                children:[
                  SizedBox(width: 24), // مساحة زر السحب
                  Expanded(flex: 3, child: Text('المادة', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('الوحدة', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  SizedBox(width: 30), // مساحة لزر الحذف
                ],
              ),
            ),

            // 🔴 الإضافة الجديدة: ترتيب بالسحب والإفلات
            Expanded(
              child: _lines.isEmpty
                  ? const Center(child: Text('لم يتم إضافة مواد للمناقلة', style: TextStyle(color: Colors.grey)))
                  : ReorderableListView.builder(
                itemCount: _lines.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _lines.removeAt(oldIndex);
                    _lines.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final line = _lines[index];
                  return Container(
                    key: ValueKey('${line.product.id}_$index'),
                    color: Colors.white,
                    child: Column(
                      children:[
                        Row(
                          children:[
                            // زر السحب
                            ReorderableDragStartListener(
                              index: index,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.drag_indicator, size: 20, color: Colors.grey),
                              ),
                            ),
                            Expanded(flex: 3, child: Text(line.product.name, style: const TextStyle(fontWeight: FontWeight.bold))),

                            // 🔴 زر الوحدة قابل للضغط
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () => _editUnit(line),
                                child: Center(child: Text(line.unitName, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () => _editQuantity(line),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                                  child: Center(child: Text(CurrencyUtils.format(line.quantity), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                                ),
                              ),
                            ),

                            if (!_isReadOnly)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => setState(() => _lines.removeAt(index)),
                              )
                            else
                              const SizedBox(width: 48),
                          ],
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (!_isReadOnly)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  onPressed: _addProducts,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة مواد للمناقلة'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                ),
              ),

            // ─── أزرار الحفظ ───
            if (!_isReadOnly)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Row(
                  children:[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _saveTransfer(issue: false),
                        child: Text(_status == 'ISSUED' ? 'تعديل وحفظ كمُخرجة' : 'حفظ مسودة'),
                      ),
                    ),
                    if (_status == 'DRAFT') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                          onPressed: () => _saveTransfer(issue: true),
                          child: const Text('تخريج المناقلة'),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}