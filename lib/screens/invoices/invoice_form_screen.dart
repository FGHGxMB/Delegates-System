import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/daos/vouchers_dao.dart'; // 🔴 إضافة هامة لإنشاء السندات
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
  bool _canPopScope = false;
  bool _showRealItems = false;

  // 🔴 الإضافة الهامة: فصلنا ID الفاتورة عن الـ widget لكي نتمكن من تصفيره لاحقاً
  int _currentInvoiceId = 0;
  String _status = 'DRAFT';
  DateTime _date = DateTime.now();
  String _paymentMethod = 'CASH';
  String _currency = 'SYP';
  double _exchangeRate = 1.0;
  Customer? _selectedCustomer;

  final _noteCtrl = TextEditingController();
  final _discountCtrl = TextEditingController(text: '0');
  final _customerSearchCtrl = TextEditingController();

  List<InvoiceLineUI> _lines = [];
  List<Customer> _allCustomers =[];

  @override
  void initState() {
    super.initState();
    _currentInvoiceId = widget.invoiceId;
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = ref.read(settingsDaoProvider);
    final invDao = ref.read(invoicesDaoProvider);
    final custDao = ref.read(customersDaoProvider);

    final rateStr = await settings.getValue('exchange_rate') ?? '1';
    _exchangeRate = double.tryParse(rateStr) ?? 1.0;

    _allCustomers = await custDao.db.select(custDao.db.customers).get();

    if (_currentInvoiceId != 0) {
      final data = await invDao.getInvoiceWithLines(_currentInvoiceId);
      if (data != null) {
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

    if (_status == 'SENT') _canPopScope = true;
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
    if (_exchangeRate <= 0) return;

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

          if (autoLoadPrices) {
            retailSnap = unit == 1 ? p.unit1PriceRetail : unit == 2 ? p.unit2PriceRetail! : p.unit3PriceRetail!;
            wholesaleSnap = unit == 1 ? p.unit1PriceWholesale : unit == 2 ? p.unit2PriceWholesale! : p.unit3PriceWholesale!;
            price = wholesaleSnap;

            if (_currency == 'SYP' && p.currency == 'USD') {
              price *= _exchangeRate; retailSnap *= _exchangeRate; wholesaleSnap *= _exchangeRate;
            } else if (_currency == 'USD' && p.currency == 'SYP') {
              price /= _exchangeRate; retailSnap /= _exchangeRate; wholesaleSnap /= _exchangeRate;
            }
          }

          _lines.add(InvoiceLineUI(
            product: p, unitNumber: unit, unitName: unitName, quantity: 1.0,
            price: price, retailSnapshot: retailSnap, wholesaleSnapshot: wholesaleSnap,
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
            decoration: InputDecoration(
                suffixText: field == 'QTY' ? line.unitName : _currency,
                // 🔴 الميزة المطلوبة 1: زر الحذف السريع داخل النافذة
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () => ctrl.clear(),
                )
            ),
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
                    if (line.quantity > 0) line.price = val / line.quantity;
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
    //[تم اختصار الكود هنا للحفاظ على المساحة، إنه نفس الكود الخاص بك بالضبط]
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

        double rSnap = selected == 1 ? line.product.unit1PriceRetail : selected == 2 ? line.product.unit2PriceRetail! : line.product.unit3PriceRetail!;
        double wSnap = selected == 1 ? line.product.unit1PriceWholesale : selected == 2 ? line.product.unit2PriceWholesale! : line.product.unit3PriceWholesale!;
        double p = wSnap;

        if (_currency == 'SYP' && line.product.currency == 'USD') {
          p *= _exchangeRate; rSnap *= _exchangeRate; wSnap *= _exchangeRate;
        } else if (_currency == 'USD' && line.product.currency == 'SYP') {
          p /= _exchangeRate; rSnap /= _exchangeRate; wSnap /= _exchangeRate;
        }

        line.price = p; line.retailSnapshot = rSnap; line.wholesaleSnapshot = wSnap;
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

  void _confirmDeleteInvoice() {
    //[نفس كودك السابق لعملية الحذف]
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحذير الحذف', style: TextStyle(color: Colors.red)),
        content: const Text('هل أنت متأكد من حذف هذه الفاتورة نهائياً؟'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(invoicesDaoProvider).deleteInvoice(_currentInvoiceId);
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

  // 🔴 الميزة المطلوبة 3: الدرج السحري للإجراءات السريعة بعد التخريج 🔴
  void _showPostIssueActionSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // يغلق عند النقر خارجه
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('تم تخريج الفاتورة بنجاح! ماذا بعد؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const Divider(),
                // 1. إنشاء سند قبض (مفعل فقط للزبائن)
                ListTile(
                  enabled: _selectedCustomer != null,
                  leading: Icon(Icons.monetization_on, color: _selectedCustomer != null ? Colors.green : Colors.grey),
                  title: const Text('إنشاء سند قبض (استلام دفعة)', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: _selectedCustomer == null ? const Text('متاح للفواتير المرتبطة بزبون فقط') : null,
                  onTap: () {
                    // نفتح نافذة السند فوق الدرج (بدون إغلاق الدرج)
                    _showQuickReceiptDialog();
                  },
                ),
                // 2. إنشاء فاتورة جديدة
                ListTile(
                  leading: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                  title: const Text('إنشاء فاتورة جديدة (تصفير)', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(sheetContext); // نغلق الدرج
                    _resetForNewInvoice(); // نصفر الشاشة
                  },
                ),
                // 3. إغلاق والعودة
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: const Text('إغلاق والعودة للقائمة', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(sheetContext); // نغلق الدرج
                    context.pop(); // نغلق شاشة الفاتورة
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // نافذة الإدخال السريع لسند القبض
  Future<void> _showQuickReceiptDialog() async {
    final amountCtrl = TextEditingController(text: CurrencyUtils.format(_netTotal));

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('سند قبض من: ${_selectedCustomer!.name}'),
          content: TextField(
            controller: amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'المبلغ المستلم',
              suffixIcon: IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => amountCtrl.clear()),
            ),
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                double amount = CurrencyUtils.parse(amountCtrl.text);
                if(amount <= 0) return;

                final settings = ref.read(settingsDaoProvider);
                String sypBox = await settings.getValue('delegate_syp_box_code') ?? '';
                String usdBox = await settings.getValue('delegate_usd_box_code') ?? '';
                String customerPrefix = await settings.getValue('customer_account_code_prefix') ?? '';

                String cashCode = _currency == 'USD' ? usdBox : sypBox;
                String customerCode = '$customerPrefix${_selectedCustomer!.accountCode}';

                final vDao = ref.read(vouchersDaoProvider);
                final companion = VouchersCompanion(
                  type: const drift.Value('RECEIPT'),
                  status: const drift.Value('ISSUED'),
                  date: drift.Value('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
                  debitAccount: drift.Value(cashCode),
                  creditAccount: drift.Value(customerCode),
                  amount: drift.Value(amount),
                  currency: drift.Value(_currency),
                  exchangeRate: drift.Value(_exchangeRate),
                  note: drift.Value('دفعة عن فاتورة مبيعات'),
                );

                await vDao.saveVoucher(companion);

                if(context.mounted) {
                  Navigator.pop(ctx); // إغلاق نافذة إدخال المبلغ (ليبقى الدرج مفتوحاً)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء وتخريج السند بنجاح!'), backgroundColor: Colors.green));
                }
              },
              child: const Text('حفظ السند'),
            )
          ],
        )
    );
  }

  // دالة تصفير الشاشة للبدء بفاتورة جديدة
  void _resetForNewInvoice() {
    setState(() {
      _currentInvoiceId = 0; // ID جديد
      _status = 'DRAFT';
      _canPopScope = false;
      _lines.clear();
      _discountCtrl.text = '0';
      _selectedCustomer = null;
      _customerSearchCtrl.clear();
      // التاريخ والبيان (_noteCtrl) يبقيان كما هما !
    });
  }

  Future<void> _saveInvoice({bool issue = false}) async {
    if (_lines.any((l) => !l.isGift && l.price <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عذراً، هناك مواد بدون سعر!'), backgroundColor: Colors.red));
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
      id: _currentInvoiceId == 0 ? const drift.Value.absent() : drift.Value(_currentInvoiceId),
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

    // 🔴 نحتفظ بالـ ID الجديد الذي تم توليده
    int savedId = await invDao.saveInvoice(invoiceCompanion, linesCompanion);

    if (mounted) {
      setState(() {
        _currentInvoiceId = savedId;
        _status = newStatus;
        _canPopScope = true;
      });

      // إذا تم التخريج لأول مرة (كانت مسودة أو جديدة وأصبحت ISSUED) نظهر الدرج!
      if (issue) {
        _showPostIssueActionSheet();
      } else {
        // إذا كان مجرد حفظ مسودة، نخرج ببساطة
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ كمسودة بنجاح')));
        context.pop();
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
        final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج', style: TextStyle(color: Colors.red)),
            content: const Text('هل أنت متأكد من الخروج؟ سيتم فقدان التغييرات.'),
            actions:[
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('البقاء')),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.of(context).pop(true), child: const Text('تأكيد الخروج')),
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
          title: Text(widget.type == 'SALE' ? AppStrings.salesInvoice : AppStrings.returnInvoice, style: const TextStyle(fontSize: 16)),
          backgroundColor: widget.type == 'SALE' ? AppColors.primary : Colors.orange[800],
          actions:[
            Builder(builder: (context) {
              int fakeItemsCount = _lines.where((line) => line.realProduct != null).length;
              if (fakeItemsCount > 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Center(
                    child: Badge(
                      label: Text('$fakeItemsCount'),
                      child: IconButton(
                        icon: Icon(_showRealItems ? Icons.visibility : Icons.visibility_off, color: _showRealItems ? Colors.redAccent : Colors.white),
                        tooltip: 'إظهار/إخفاء المواد الحقيقية',
                        onPressed: () => setState(() => _showRealItems = !_showRealItems),
                      ),
                    ),
                  ),
                );
              } else {
                return const IconButton(icon: Icon(Icons.visibility_off, color: Colors.white38), onPressed: null);
              }
            }),

            if (_currentInvoiceId != 0 && _status != 'SENT')
              IconButton(icon: const Icon(Icons.delete, color: Colors.white), tooltip: 'حذف الفاتورة', onPressed: _confirmDeleteInvoice),

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
                          onChanged: (_isReadOnly || _selectedCustomer != null) ? null : (val) => setState(() => _currency = val!),
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
                          suffixIcon: _selectedCustomer != null && !_isReadOnly
                              ? IconButton(icon: const Icon(Icons.clear, size: 20, color: Colors.red), onPressed: () => setState(() { _selectedCustomer = null; _customerSearchCtrl.clear(); }))
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

            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: const Row(
                children:[
                  SizedBox(width: 24),
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
                      children:[
                        Row(
                          children:[
                            ReorderableDragStartListener(index: index, child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.drag_indicator, size: 18, color: Colors.grey))),
                            Expanded(flex: 3, child: InkWell(
                              onLongPress: () => _showLineOptions(index),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(line.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  if (_showRealItems && line.realProduct != null) Text('👁️ ${line.realProduct!.name}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
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
                              child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(line.isGift ? '---' : CurrencyUtils.format(line.price), style: TextStyle(color: line.isGift ? Colors.grey : Colors.blue, fontSize: 12), overflow: TextOverflow.ellipsis)),
                            )),
                            Expanded(flex: 2, child: InkWell(
                              onTap: line.isGift ? null : () => _editNumericCell(line, 'TOTAL'),
                              child: Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, child: Text(line.isGift ? '---' : CurrencyUtils.format(line.total), style: TextStyle(color: line.isGift ? Colors.grey : Colors.green, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
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

            // ─── الإجماليات + الميزة المطلوبة 2: حقل البيان ───
            Container(
              color: Colors.blue[50],
              padding: const EdgeInsets.all(12),
              child: Column(
                children:[
                  // 🔴 الإضافة: حقل البيان (Note) 🔴
                  TextField(
                    controller: _noteCtrl,
                    enabled: !_isReadOnly,
                    decoration: const InputDecoration(
                      labelText: 'بيان الفاتورة (ملاحظات للطباعة والإكسيل)',
                      isDense: true,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[const Text('المجموع الفرعي:'), Text('${CurrencyUtils.format(_subtotal)} $_currency')]),
                  Row(
                    children:[
                      const Text('الحسم:'),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _discountCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          enabled: !_isReadOnly,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            // زر مسح للحسميات أيضاً
                            suffixIcon: _discountCtrl.text != '0' && !_isReadOnly
                                ? IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () => setState(() => _discountCtrl.text = '0'))
                                : null,
                          ),
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
      ),
    );
  }
}