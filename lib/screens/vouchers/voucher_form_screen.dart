import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/vouchers_dao.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/database.dart';
import '../../utils/currency_utils.dart';
import '../../providers/database_provider.dart';

// ─── كلاس مساعد لجمع الزبائن والحسابات في قائمة واحدة ───
class CounterpartItem {
  final String code;
  final String name;
  final String currency;
  final bool isCustomer;

  CounterpartItem({required this.code, required this.name, required this.currency, required this.isCustomer});

  String get displayName => isCustomer ? '$name (زبون)' : '$name (حساب)';
}

class VoucherFormScreen extends ConsumerStatefulWidget {
  final String type; // 'RECEIPT' أو 'PAYMENT'
  final int voucherId; // 0 تعني سند جديد

  const VoucherFormScreen({Key? key, required this.type, required this.voucherId}) : super(key: key);

  @override
  ConsumerState<VoucherFormScreen> createState() => _VoucherFormScreenState();
}

class _VoucherFormScreenState extends ConsumerState<VoucherFormScreen> {
  bool _isLoading = true;
  bool _canPopScope = false;

  String _status = 'DRAFT';
  DateTime _date = DateTime.now();
  String _currency = 'SYP';
  double _amount = 0.0;
  double _exchangeRate = 1.0;

  CounterpartItem? _selectedCounterpart;

  final _noteCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  List<CounterpartItem> _allCounterparts =[];

  String _cashAccountSyp = '';
  String _cashAccountUsd = '';
  String _mainCustomerPrefix = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = ref.read(settingsDaoProvider);
    final db = ref.read(databaseProvider);

    // 1. جلب الإعدادات وأسعار الصرف وصناديق المندوب
    final rateStr = await settings.getValue('exchange_rate') ?? '1';
    _exchangeRate = double.tryParse(rateStr) ?? 1.0;

    _cashAccountSyp = await settings.getValue('cash_account_syp') ?? '';
    _cashAccountUsd = await settings.getValue('cash_account_usd') ?? '';
    _mainCustomerPrefix = await settings.getValue('main_account_prefix') ?? '12101';

    // 2. بناء قائمة ذكية تجمع (الزبائن + الحسابات)
    final customers = await db.select(db.customers).get();
    final accounts = await db.select(db.accounts).get();

    _allCounterparts =[
      ...customers.map((c) => CounterpartItem(
          code: '$_mainCustomerPrefix${c.accountCode}',
          name: c.name,
          currency: c.currency,
          isCustomer: true)),
      // نستثني صناديق المندوب من القائمة كي لا يحول المندوب لنفسه!
      ...accounts.where((a) => a.code != _cashAccountSyp && a.code != _cashAccountUsd).map((a) => CounterpartItem(
          code: a.code,
          name: a.name,
          currency: a.currency,
          isCustomer: false))
    ];

    // 3. جلب بيانات السند في حال التعديل
    if (widget.voucherId != 0) {
      final vDao = ref.read(vouchersDaoProvider);
      final v = await vDao.getVoucherById(widget.voucherId);
      if (v != null) {
        _status = v.status;
        _date = DateTime.parse(v.date);
        _currency = v.currency;
        _amount = v.amount;
        _exchangeRate = v.exchangeRate ?? _exchangeRate;
        _noteCtrl.text = v.note ?? '';
        _amountCtrl.text = CurrencyUtils.format(v.amount);

        // من هو الطرف الآخر؟
        String counterpartCode = widget.type == 'RECEIPT' ? v.creditAccount : v.debitAccount;

        try {
          _selectedCounterpart = _allCounterparts.firstWhere((c) => c.code == counterpartCode);
          _searchCtrl.text = _selectedCounterpart!.displayName;
        } catch (e) {
          _searchCtrl.text = counterpartCode;
        }
      }
    }

    if (_status == 'SENT') _canPopScope = true;

    setState(() => _isLoading = false);
  }

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

  void _onCounterpartSelected(CounterpartItem item) {
    if (_isReadOnly) return;
    setState(() {
      _selectedCounterpart = item;
      _searchCtrl.text = item.displayName;

      // السحر هنا: تغيير وقفل العملة تلقائياً بناءً على الحساب
      if (item.currency == 'SYP') {
        _currency = 'SYP';
      } else if (item.currency == 'USD') {
        _currency = 'USD';
      }
      // إذا كانت عملة الحساب 'BOTH'، نترك للمندوب حرية اختيار العملة من القائمة
    });
  }

  Future<void> _saveVoucher({bool issue = false}) async {
    final amount = CurrencyUtils.parse(_amountCtrl.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح'), backgroundColor: Colors.red));
      return;
    }
    if (_selectedCounterpart == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء تحديد الحساب المقابل'), backgroundColor: Colors.red));
      return;
    }

    // التحقق من أن المدير قام ببرمجة الصناديق في الإعدادات
    if (_currency == 'SYP' && _cashAccountSyp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لم يتم تحديد رمز صندوق الليرة في الإعدادات المحمية!'), backgroundColor: Colors.red));
      return;
    }
    if (_currency == 'USD' && _cashAccountUsd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لم يتم تحديد رمز صندوق الدولار في الإعدادات المحمية!'), backgroundColor: Colors.red));
      return;
    }

    // التحديد التلقائي لصندوق المندوب بناءً على العملة
    String cashCode = _currency == 'USD' ? _cashAccountUsd : _cashAccountSyp;
    String counterpartCode = _selectedCounterpart!.code;

    // المنطق المحاسبي الدقيق:
    // في سند القبض: الصندوق يستلم (مدين) والطرف الآخر يدفع (دائن).
    // في سند الدفع: الصندوق يدفع (دائن) والطرف الآخر يستلم (مدين).
    String debit = widget.type == 'RECEIPT' ? cashCode : counterpartCode;
    String credit = widget.type == 'RECEIPT' ? counterpartCode : cashCode;

    String newStatus = issue ? 'ISSUED' : _status;

    final companion = VouchersCompanion(
      id: widget.voucherId == 0 ? const drift.Value.absent() : drift.Value(widget.voucherId),
      type: drift.Value(widget.type),
      status: drift.Value(newStatus),
      date: drift.Value('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
      debitAccount: drift.Value(debit),
      creditAccount: drift.Value(credit),
      amount: drift.Value(amount),
      currency: drift.Value(_currency),
      exchangeRate: drift.Value(_exchangeRate),
      note: drift.Value(_noteCtrl.text.trim()),
    );

    await ref.read(vouchersDaoProvider).saveVoucher(companion);

    if (mounted) {
      setState(() => _canPopScope = true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(issue ? 'تم تخريج السند بنجاح' : 'تم الحفظ بنجاح')));
      context.pop();
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحذير الحذف', style: TextStyle(color: Colors.red)),
        content: const Text('هل أنت متأكد من حذف هذا السند نهائياً؟'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(vouchersDaoProvider).deleteVoucher(widget.voucherId);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final isReceipt = widget.type == 'RECEIPT';
    final title = isReceipt ? AppStrings.receiptVoucher : AppStrings.paymentVoucher;
    final color = isReceipt ? AppColors.success : Colors.redAccent;

    return PopScope(
      canPop: _canPopScope,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج', style: TextStyle(color: Colors.red)),
            content: const Text('سيتم فقدان أي تغييرات لم تقم بحفظها.'),
            actions:[
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('البقاء')),
              FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.of(context).pop(true), child: const Text('خروج')),
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
          title: Text(title, style: const TextStyle(fontSize: 16)),
          backgroundColor: color,
          foregroundColor: Colors.white,
          actions:[
            if (widget.voucherId != 0 && _status != 'SENT')
              IconButton(icon: const Icon(Icons.delete), tooltip: 'حذف السند', onPressed: _confirmDelete),
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              // ─── التاريخ والعملة ───
              Row(
                children:[
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'تاريخ السند', border: OutlineInputBorder()),
                        child: Text('${_date.year}-${_date.month}-${_date.day}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: const InputDecoration(labelText: 'العملة (تُحدد الصندوق)', border: OutlineInputBorder()),
                      items: const[
                        DropdownMenuItem(value: 'SYP', child: Text('ل.س', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))),
                        DropdownMenuItem(value: 'USD', child: Text('دولار \$', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)))
                      ],
                      // يتم تعطيل العملة إذا كان الحساب المقابل لديه عملة صارمة لكي لا يخطئ المندوب!
                      onChanged: (_isReadOnly || (_selectedCounterpart != null && _selectedCounterpart!.currency != 'BOTH'))
                          ? null
                          : (val) => setState(() => _currency = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── الحساب المقابل (ذكاء اصطناعي محلي) ───
              RawAutocomplete<CounterpartItem>(
                textEditingController: _searchCtrl,
                focusNode: FocusNode(),
                displayStringForOption: (item) => item.displayName,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) return _allCounterparts;
                  return _allCounterparts.where((c) => c.displayName.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                fieldViewBuilder: (context, ctrl, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: ctrl,
                    focusNode: focusNode,
                    enabled: !_isReadOnly,
                    decoration: InputDecoration(
                      labelText: isReceipt ? 'مُستلَم من (الزبون / الحساب)' : 'مَدفوع إلى (الزبون / المصروف)',
                      border: const OutlineInputBorder(),
                      suffixIcon: _selectedCounterpart != null && !_isReadOnly
                          ? IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () {
                        setState(() {
                          _selectedCounterpart = null;
                          _searchCtrl.clear();
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
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: ListView(
                          padding: EdgeInsets.zero, shrinkWrap: true,
                          children: options.map((item) => ListTile(
                            title: Text(item.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('العملة: ${item.currency == 'BOTH' ? 'ل.س / دولار' : item.currency} | الرمز: ${item.code}'),
                            leading: Icon(item.isCustomer ? Icons.person : Icons.account_balance, color: AppColors.primary),
                            onTap: () { onSelected(item); _onCounterpartSelected(item); },
                          )).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ─── المبلغ ───
              TextField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                enabled: !_isReadOnly,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                decoration: InputDecoration(
                  labelText: 'المبلغ ($_currency)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.monetization_on, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: 16),

              // ─── البيان ───
              TextField(
                controller: _noteCtrl,
                enabled: !_isReadOnly,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'بيان السند (ملاحظات)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              // ─── أزرار الحفظ ───
              if (!_isReadOnly)
                Row(
                  children:[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _saveVoucher(issue: false),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: Text(_status == 'ISSUED' ? 'تعديل وحفظ كمُخرَج' : 'حفظ كمسودة'),
                      ),
                    ),
                    if (_status == 'DRAFT') ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _saveVoucher(issue: true),
                          style: FilledButton.styleFrom(backgroundColor: AppColors.success, padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Text('تخريج السند'),
                        ),
                      ),
                    ]
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}