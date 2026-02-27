import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/database.dart';
import '../../utils/currency_utils.dart';
import 'product_selection_screen.dart';

class InvoiceLineUI {
  final Product product;
  Product? realProduct;
  int unitNumber;
  String unitName;
  double quantity;
  double price;
  double retailSnapshot;
  double wholesaleSnapshot;
  bool isGift;
  String note;

  InvoiceLineUI({
    required this.product,
    this.realProduct,
    required this.unitNumber,
    required this.unitName,
    required this.quantity,
    required this.price,
    required this.retailSnapshot,
    required this.wholesaleSnapshot,
    this.isGift = false,
    this.note = '',
  });

  double get total => isGift ? 0 : (quantity * price);
}

class InvoiceFormScreen extends ConsumerStatefulWidget {
  final String type;
  final int invoiceId;

  const InvoiceFormScreen({Key? key, required this.type, required this.invoiceId}) : super(key: key);

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  bool _isLoading = true;
  Invoice? _existingInvoice;

  String _status = 'DRAFT';
  DateTime _date = DateTime.now();
  String _paymentMethod = 'CASH';
  String _currency = 'SYP';
  double _exchangeRate = 1.0;
  Customer? _selectedCustomer;

  final _noteCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '0');
  final _customerSearchCtrl = TextEditingController();

  List<InvoiceLineUI> _lines =[];
  List<Customer> _allCustomers =[];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = ref.read(settingsDaoProvider);
    final invDao = ref.read(invoicesDaoProvider);
    final custDao = ref.read(customersDaoProvider);

    final rateStr = await settings.getValue('exchange_rate') ?? '1';
    _exchangeRate = double.tryParse(rateStr) ?? 1.0;

    _allCustomers = await custDao.db.select(custDao.db.customers).get();

    if (widget.invoiceId != 0) {
      final data = await invDao.getInvoiceWithLines(widget.invoiceId);
      if (data != null) {
        _existingInvoice = data.invoice;
        _status = data.invoice.status;
        _date = DateTime.parse(data.invoice.date);
        _paymentMethod = data.invoice.paymentMethod;
        _currency = data.invoice.currency;
        _exchangeRate = data.invoice.exchangeRate ?? _exchangeRate;
        _noteCtrl.text = data.invoice.note ?? '';
        _discountCtrl.text = CurrencyUtils.format(data.invoice.discountAmount);

        if (data.invoice.customerId != null) {
          _selectedCustomer = _allCustomers.firstWhere((c) => c.id == data.invoice.customerId);
          _customerSearchCtrl.text = _selectedCustomer!.name;
        }

        final products = await invDao.db.select(invDao.db.products).get();
        _lines = data.lines.map((l) {
          final p = products.firstWhere((prod) => prod.id == l.productId);
          Product? realP;
          if (l.realProductId != null) {
            realP = products.firstWhere((prod) => prod.id == l.realProductId);
          }
          return InvoiceLineUI(
            product: p,
            realProduct: realP,
            unitNumber: l.unitNumber,
            unitName: l.unitName ?? '',
            quantity: l.quantity,
            price: l.price,
            retailSnapshot: l.priceRetailSnapshot ?? 0,
            wholesaleSnapshot: l.priceWholesaleSnapshot ?? 0,
            isGift: l.isGift,
            note: l.lineNote ?? '',
          );
        }).toList();
      }
    }
    setState(() => _isLoading = false);
  }

  double get _subtotal => _lines.fold(0, (sum, line) => sum + line.total);
  double get _discount => CurrencyUtils.parse(_discountCtrl.text);
  double get _netTotal => _subtotal - _discount;

  bool get _isReadOnly => _status == 'SENT';

  Future<void> _selectDate() async {
    if (_isReadOnly) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _addProducts() async {
    if (_exchangeRate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('خطأ: سعر الصرف يجب أن يكون أكبر من الصفر!'), backgroundColor: Colors.red));
      return;
    }

    // 1. جلب إعداد "تحميل الأسعار تلقائياً" من قاعدة البيانات
    final settings = ref.read(settingsDaoProvider);
    final autoLoadStr = await settings.getValue('auto_load_prices') ?? '1';
    final bool autoLoadPrices = autoLoadStr == '1';

    final selectedProducts = await Navigator.push<List<Product>>(
      context,
      MaterialPageRoute(builder: (_) => const ProductSelectionScreen(isSingleSelection: false)),
    );

    if (selectedProducts != null && selectedProducts.isNotEmpty && mounted) {
      setState(() {
        for (var p in selectedProducts) {
          int unit = p.defaultUnit;
          String unitName = unit == 1 ? p.unit1Name : unit == 2 ? p.unit2Name! : p.unit3Name!;

          double price = 0.0;
          double retailSnap = 0.0;
          double wholesaleSnap = 0.0;

          // 2. إذا كان الإعداد مفعلاً، نقوم بحساب السعر والتحويل
          if (autoLoadPrices) {
            price = unit == 1 ? p.unit1PriceRetail : unit == 2 ? p.unit2PriceRetail! : p.unit3PriceRetail!;
            retailSnap = price;
            wholesaleSnap = unit == 1 ? p.unit1PriceWholesale : unit == 2 ? p.unit2PriceWholesale! : p.unit3PriceWholesale!;

            // التحويل الدقيق للأسعار حسب العملة
            if (_currency == 'SYP' && p.currency == 'USD') {
              price = price * _exchangeRate;
              retailSnap = retailSnap * _exchangeRate;
              wholesaleSnap = wholesaleSnap * _exchangeRate;
            } else if (_currency == 'USD' && p.currency == 'SYP') {
              price = price / _exchangeRate;
              retailSnap = retailSnap / _exchangeRate;
              wholesaleSnap = wholesaleSnap / _exchangeRate;
            }
          }

          // 3. إضافة القلم للفاتورة (إذا كان الإعداد مطفأ سيكون السعر 0.0 تلقائياً)
          _lines.add(InvoiceLineUI(
            product: p,
            unitNumber: unit,
            unitName: unitName,
            quantity: 1.0,
            price: price,
            retailSnapshot: retailSnap,
            wholesaleSnapshot: wholesaleSnap,
          ));
        }
      });
    }
  }

  Future<void> _editNumericCell(InvoiceLineUI line, String field) async {
    if (_isReadOnly) return;

    String initialValue = field == 'QTY' ? CurrencyUtils.format(line.quantity)
        : field == 'PRICE' ? CurrencyUtils.format(line.price)
        : CurrencyUtils.format(line.total);

    final ctrl = TextEditingController(text: initialValue);

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(field == 'QTY' ? 'تعديل الكمية' : field == 'PRICE' ? 'تعديل الإفرادي' : 'تعديل الإجمالي'),
          content: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: InputDecoration(suffixText: field == 'QTY' ? line.unitName : _currency),
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
            FilledButton(
              onPressed: () {
                final val = CurrencyUtils.parse(ctrl.text);
                setState(() {
                  if (field == 'QTY') {
                    if (val > 0) line.quantity = val;
                  } else if (field == 'PRICE') {
                    line.price = val;
                  } else if (field == 'TOTAL') {
                    if (line.quantity > 0) {
                      line.price = val / line.quantity;
                    }
                  }
                });
                Navigator.pop(ctx);
              },
              child: const Text(AppStrings.save),
            )
          ],
        )
    );
  }

  Future<void> _editUnit(InvoiceLineUI line) async {
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

        double p = selected == 1 ? line.product.unit1PriceRetail : selected == 2 ? line.product.unit2PriceRetail! : line.product.unit3PriceRetail!;
        double rSnap = p;
        double wSnap = selected == 1 ? line.product.unit1PriceWholesale : selected == 2 ? line.product.unit2PriceWholesale! : line.product.unit3PriceWholesale!;

        if (_currency == 'SYP' && line.product.currency == 'USD') {
          p *= _exchangeRate;
          rSnap *= _exchangeRate;
          wSnap *= _exchangeRate;
        } else if (_currency == 'USD' && line.product.currency == 'SYP') {
          p /= _exchangeRate;
          rSnap /= _exchangeRate;
          wSnap /= _exchangeRate;
        }

        line.price = p;
        line.retailSnapshot = rSnap;
        line.wholesaleSnapshot = wSnap;
      }
    });
  }

  void _showLineOptions(int index) {
    if (_isReadOnly) return;
    final line = _lines[index];

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.purple),
              title: Text(line.realProduct == null ? AppStrings.selectRealProduct : 'المادة الحقيقية: ${line.realProduct!.name}'),
              subtitle: const Text('تغيير المادة لإخفائها عن الزبون في الطباعة'),
              onTap: () async {
                Navigator.pop(ctx);
                final realPList = await Navigator.push<List<Product>>(context, MaterialPageRoute(builder: (_) => const ProductSelectionScreen(isSingleSelection: true)));
                if (realPList != null && realPList.isNotEmpty) setState(() => line.realProduct = realPList.first);
              },
            ),
            if (line.realProduct != null)
              ListTile(
                leading: const Icon(Icons.clear, color: Colors.orange),
                title: const Text(AppStrings.removeRealProduct),
                onTap: () { setState(() => line.realProduct = null); Navigator.pop(ctx); },
              ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.card_giftcard, color: line.isGift ? Colors.grey : Colors.pink),
              title: Text(line.isGift ? AppStrings.removeGift : AppStrings.markAsGift),
              onTap: () { setState(() => line.isGift = !line.isGift); Navigator.pop(ctx); },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(AppStrings.delete, style: TextStyle(color: Colors.red)),
              onTap: () { setState(() => _lines.removeAt(index)); Navigator.pop(ctx); },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInvoice({bool issue = false}) async {
    if (_lines.any((l) => !l.isGift && l.price <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('عذراً، هناك مواد بدون سعر! يرجى تسعيرها أو جعلها هدية (🎁)'),
          backgroundColor: Colors.red));
      return;
    }

    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.documentNoProducts), backgroundColor: Colors.red));
      return;
    }
    if (_paymentMethod == 'CREDIT' && _selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.creditInvoiceNeedsCustomer), backgroundColor: Colors.red));
      return;
    }

    final invDao = ref.read(invoicesDaoProvider);

    String newStatus = _status;
    if (issue) newStatus = 'ISSUED';

    final invoiceCompanion = InvoicesCompanion(
      id: widget.invoiceId == 0 ? const drift.Value.absent() : drift.Value(widget.invoiceId),
      type: drift.Value(widget.type),
      status: drift.Value(newStatus),
      date: drift.Value('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
      customerId: drift.Value(_selectedCustomer?.id),
      paymentMethod: drift.Value(_paymentMethod),
      currency: drift.Value(_currency),
      exchangeRate: drift.Value(_exchangeRate),
      subtotal: drift.Value(_subtotal),
      discountAmount: drift.Value(_discount),
      total: drift.Value(_netTotal),
      note: drift.Value(_noteCtrl.text.trim()),
    );

    final linesCompanion = _lines.map((l) => InvoiceLinesCompanion(
      productId: drift.Value(l.product.id),
      productCode: drift.Value(l.product.code),
      productName: drift.Value(l.product.name),
      realProductId: drift.Value(l.realProduct?.id),
      realProductCode: drift.Value(l.realProduct?.code),
      realProductName: drift.Value(l.realProduct?.name),
      unitNumber: drift.Value(l.unitNumber),
      unitName: drift.Value(l.unitName),
      quantity: drift.Value(l.quantity),
      price: drift.Value(l.price),
      priceRetailSnapshot: drift.Value(l.retailSnapshot),
      priceWholesaleSnapshot: drift.Value(l.wholesaleSnapshot),
      isGift: drift.Value(l.isGift),
      lineNote: drift.Value(l.note),
    )).toList();

    await invDao.saveInvoice(invoiceCompanion, linesCompanion);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(issue ? 'تم تخريج الفاتورة بنجاح' : 'تم الحفظ بنجاح')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'SALE' ? AppStrings.salesInvoice : AppStrings.returnInvoice, style: const TextStyle(fontSize: 16)),
        backgroundColor: widget.type == 'SALE' ? AppColors.primary : Colors.orange[800],
        actions:[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(
                label: Text(_status == 'DRAFT' ? AppStrings.invoiceDraft : _status == 'ISSUED' ? AppStrings.invoiceIssued : AppStrings.invoiceSent, style: const TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: _status == 'DRAFT' ? AppColors.draftColor : _status == 'ISSUED' ? AppColors.issuedColor : AppColors.sentColor,
                visualDensity: VisualDensity.compact,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children:[
          // ─── رأس الفاتورة الأنيق ───
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:[
                Row(
                  children:[
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'التاريخ', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                          child: Text('${_date.year}-${_date.month}-${_date.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currency,
                        decoration: const InputDecoration(labelText: 'العملة', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: const[DropdownMenuItem(value: 'SYP', child: Text('ل.س')), DropdownMenuItem(value: 'USD', child: Text('دولار \$'))],
                        // تم إضافة شرط لتعطيل تغيير العملة إذا كان هناك زبون محدد
                        onChanged: (_isReadOnly || _selectedCustomer != null) ? null : (val) {
                          setState(() {
                            _currency = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        decoration: const InputDecoration(labelText: 'الدفع', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                        items: const[DropdownMenuItem(value: 'CASH', child: Text('نقدي')), DropdownMenuItem(value: 'CREDIT', child: Text('آجل'))],
                        onChanged: _isReadOnly ? null : (val) => setState(() => _paymentMethod = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RawAutocomplete<Customer>(
                  textEditingController: _customerSearchCtrl,
                  focusNode: FocusNode(),
                  displayStringForOption: (c) => c.name,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) return _allCustomers.where((c) => c.currency == _currency);
                    return _allCustomers.where((c) => c.currency == _currency && c.name.contains(textEditingValue.text));
                  },
                  fieldViewBuilder: (context, ctrl, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: ctrl,
                      focusNode: focusNode,
                      enabled: !_isReadOnly,
                      decoration: InputDecoration(
                        labelText: 'الزبون (حسب عملة الفاتورة)',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        // زر تفريغ حقل الزبون باللون الأحمر واضح للمندوب
                        suffixIcon: _selectedCustomer != null && !_isReadOnly
                            ? IconButton(icon: const Icon(Icons.clear, size: 20, color: Colors.red), onPressed: () {
                          setState(() {
                            _selectedCustomer = null;
                            _customerSearchCtrl.clear();
                          });
                        })
                            : null,
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView(
                            padding: EdgeInsets.zero, shrinkWrap: true,
                            children: options.map((Customer c) => ListTile(title: Text(c.name), onTap: () { setState(() { _selectedCustomer = c; _customerSearchCtrl.text = c.name; }); onSelected(c); })).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ─── جدول المواد ───
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: const Row(
              children:[
                SizedBox(width: 24), // مساحة السحب
                Expanded(flex: 3, child: Text('المادة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 1, child: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('الوحدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('الإفرادي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),

          Expanded(
            child: _lines.isEmpty
                ? const Center(child: Text('لم يتم إضافة مواد', style: TextStyle(color: Colors.grey)))
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
                  color: line.isGift ? AppColors.giftBackground : (line.realProduct != null ? Colors.purple[50] : Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children:[
                          ReorderableDragStartListener(
                            index: index,
                            child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.drag_indicator, size: 18, color: Colors.grey)),
                          ),
                          Expanded(flex: 3, child: InkWell(
                            onLongPress: () => _showLineOptions(index),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(line.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                if (line.realProduct != null) Text('👁️ ${line.realProduct!.name}', style: const TextStyle(color: Colors.purple, fontSize: 10)),
                                if (line.isGift) const Text('🎁 هدية', style: TextStyle(color: Colors.pink, fontSize: 10)),
                              ],
                            ),
                          )),
                          Expanded(flex: 1, child: InkWell(
                            onTap: () => _editNumericCell(line, 'QTY'),
                            child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(CurrencyUtils.format(line.quantity), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))),
                          )),
                          Expanded(flex: 2, child: InkWell(
                            onTap: () => _editUnit(line),
                            child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(line.unitName, style: const TextStyle(color: Colors.blue, fontSize: 12), overflow: TextOverflow.ellipsis)),
                          )),
                          Expanded(flex: 2, child: InkWell(
                            onTap: line.isGift ? null : () => _editNumericCell(line, 'PRICE'),
                            child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center,
                                child: Text(line.isGift ? '---' : CurrencyUtils.format(line.price), style: TextStyle(color: line.isGift ? Colors.grey : Colors.blue, fontSize: 12), overflow: TextOverflow.ellipsis)),
                          )),
                          Expanded(flex: 2, child: InkWell(
                            onTap: line.isGift ? null : () => _editNumericCell(line, 'TOTAL'),
                            child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center,
                                child: Text(line.isGift ? '---' : CurrencyUtils.format(line.total), style: TextStyle(color: line.isGift ? Colors.grey : Colors.green, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                          )),
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
                label: const Text('إضافة مواد للفاتورة'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
              ),
            ),

          // ─── الإجماليات ───
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.all(12),
            child: Column(
              children:[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[const Text('المجموع الفرعي:'), Text('${CurrencyUtils.format(_subtotal)} $_currency')]),
                Row(
                  children:[
                    const Text('الحسم:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _discountCtrl,
                        keyboardType: TextInputType.number,
                        enabled: !_isReadOnly,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    Text(' $_currency'),
                  ],
                ),
                const Divider(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      const Text('الصافي النهائي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${CurrencyUtils.format(_netTotal)} $_currency', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary))
                    ]
                ),
              ],
            ),
          ),

          // ─── أزرار الحفظ (تظهر للمسودة والمخرجة) ───
          if (!_isReadOnly)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children:[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _saveInvoice(issue: false),
                      child: Text(_status == 'ISSUED' ? 'تعديل وحفظ كمُخرجة' : 'حفظ مسودة'),
                    ),
                  ),
                  if (_status == 'DRAFT') ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                        onPressed: () => _saveInvoice(issue: true),
                        child: const Text('تخريج الفاتورة'),
                      ),
                    ),
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }
}