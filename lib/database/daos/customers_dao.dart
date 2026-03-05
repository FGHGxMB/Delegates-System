import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class CustomersDao {
  final AppDatabase db;
  CustomersDao(this.db);

  Stream<List<Customer>> watchCustomers(String searchQuery) {
    if (searchQuery.trim().isEmpty) {
      return (db.select(db.customers)..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
    } else {
      return (db.select(db.customers)
        ..where((t) => t.name.like('%$searchQuery%') | t.accountCode.like('%$searchQuery%'))
        ..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
    }
  }

  // [تحديث] البحث عن الأحياء بناءً على المدينة المختارة
  Future<List<String>> getSuggestions(String field, String query, String city) async {
    final column = field == 'neighborhood' ? db.customers.neighborhood : db.customers.street;
    final result = await (db.selectOnly(db.customers, distinct: true)
      ..addColumns([column])
      ..where(column.like('%$query%'))
      ..where(column.isNotNull())
      ..where(db.customers.city.equals(city))) // [جديد] الفلترة بالمدينة
        .get();
    return result.map((row) => row.read(column)!).toList();
  }

  // ─── [تحديث] توليد رمز الحساب (001, 002) ───
  Future<String> generateNextSuffix() async {
    final query = db.select(db.customers)
      ..orderBy([(t) => OrderingTerm(expression: t.accountCode, mode: OrderingMode.desc)])
      ..limit(1);
    final lastCustomer = await query.getSingleOrNull();
    if (lastCustomer == null) return '001';
    final lastInt = int.tryParse(lastCustomer.accountCode) ?? 0;
    return (lastInt + 1).toString().padLeft(3, '0');
  }

  // ─── التحقق من التكرار (مُصححة) ───
  Future<bool> isNameExists(String name, int excludeId) async {
    final query = db.select(db.customers)
      ..where((t) => t.name.equals(name) & t.id.equals(excludeId).not());
    final result = await query.get();
    return result.isNotEmpty;
  }

  // حفظ الزبون
  Future<void> saveCustomer(CustomersCompanion customer, {bool isNew = false}) async {
    if (isNew) {
      final newSuffix = await generateNextSuffix();
      await db.into(db.customers).insert(customer.copyWith(
        accountCode: Value(newSuffix),
        createdAt: Value(DateTime.now()),
        isModified: const Value(false),
        isSent: const Value(false),
      ));
    } else {
      await db.update(db.customers).replace(customer.copyWith(
        isModified: const Value(true), // نعلمه كمعدل
        isSent: const Value(false),
      ));
    }
  }

  // ───[معدل] حماية الحذف (فواتير + سندات) ───
  Future<bool> deleteCustomer(int id) async {
    // 1. التحقق من وجود فواتير
    final invoicesCount = await (db.select(db.invoices)..where((t) => t.customerId.equals(id))).get();
    if (invoicesCount.isNotEmpty) return false; // ممنوع الحذف لوجود فواتير

    // 2. جلب الزبون لمعرفة رمز حسابه
    final customer = await (db.select(db.customers)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (customer == null) return false; // الزبون غير موجود أصلاً

    // 3. التحقق من وجود سندات (كطرف مدين أو دائن)
    final vouchersCount = await (db.select(db.vouchers)..where((t) =>
    t.debitAccount.equals(customer.accountCode) |
    t.creditAccount.equals(customer.accountCode)
    )).get();
    if (vouchersCount.isNotEmpty) return false; // ممنوع الحذف لوجود سندات مالية

    // 4. الحذف بأمان
    await (db.delete(db.customers)..where((t) => t.id.equals(id))).go();
    return true;
  }

  // ─── تعليم كل الزبائن كمعدلين (مُصححة وأكثر أماناً) ───
  Future<void> markAllAsModified() async {
    await db.update(db.customers).write(
      const CustomersCompanion(
        isSent: Value(false),
        isModified: Value(true),
      ),
    );
  }

  // ─── جرد رصيد الزبون التفصيلي ───
  Future<Map<String, double>> getCustomerBalanceInfo(int customerId, String accountCode) async {
    double totalCreditSales = 0;
    double totalCreditReturns = 0;
    double totalReceipts = 0;
    double totalPayments = 0;

    // 1. المبيعات الآجلة (تزيد الرصيد)
    final sales = await (db.select(db.invoices)
      ..where((i) => i.customerId.equals(customerId) & i.paymentMethod.equals('CREDIT') & i.type.equals('SALE') & i.status.isNotIn(['DRAFT']))
    ).get();
    for (var inv in sales) { totalCreditSales += inv.total; }

    // 2. المرتجعات الآجلة (تنقص الرصيد)
    final returns = await (db.select(db.invoices)
      ..where((i) => i.customerId.equals(customerId) & i.paymentMethod.equals('CREDIT') & i.type.equals('RETURN') & i.status.isNotIn(['DRAFT']))
    ).get();
    for (var inv in returns) { totalCreditReturns += inv.total; }

    // 3. الدفعات المستلمة (سندات القبض - تنقص الرصيد)
    // الزبون هنا يكون "دائن" لأنه أعطانا المال
    final receipts = await (db.select(db.vouchers)
      ..where((v) => v.creditAccount.equals(accountCode) & v.type.equals('RECEIPT') & v.status.isNotIn(['DRAFT']))
    ).get();
    for (var v in receipts) { totalReceipts += v.amount; }

    // 4. الدفعات المعطاة (سندات الدفع - تزيد الرصيد)
    // الزبون هنا يكون "مدين" لأنه أخذ منا مال
    final payments = await (db.select(db.vouchers)
      ..where((v) => v.debitAccount.equals(accountCode) & v.type.equals('PAYMENT') & v.status.isNotIn(['DRAFT']))
    ).get();
    for (var v in payments) { totalPayments += v.amount; }

    // الرصيد النهائي = (المبيعات + سندات الدفع) - (المرتجعات + سندات القبض)
    double netBalance = (totalCreditSales + totalPayments) - (totalCreditReturns + totalReceipts);

    return {
      'totalCreditSales': totalCreditSales,
      'totalCreditReturns': totalCreditReturns,
      'totalReceipts': totalReceipts,
      'totalPayments': totalPayments,
      'netBalance': netBalance,
    };
  }

  // ─── للحصول على الرصيد النهائي فقط (للاستخدام السريع في القوائم) ───
  Future<double> getCustomerNetBalance(int customerId, String accountCode) async {
    final info = await getCustomerBalanceInfo(customerId, accountCode);
    return info['netBalance']!;
  }

  // ─── جلب الزبائن مع أرصدتهم كمجرى بيانات (Stream) يتحدث لحظياً ───
  Stream<List<CustomerWithBalance>> watchCustomersWithBalances(String searchQuery) {
    final searchTerm = '%${searchQuery.trim()}%';

    final query = '''
      SELECT c.*, 
      (
        -- 1. المبيعات الآجلة (تزيد ديون الزبون)
        COALESCE((SELECT SUM(total) FROM invoices WHERE customer_id = c.id AND payment_method = 'CREDIT' AND type = 'SALE' AND status != 'DRAFT'), 0)
        + 
        -- 2. 🔴 التعديل هنا: أي سند يكون الزبون فيه مديناً (تزيد ديون الزبون)
        COALESCE((SELECT SUM(amount) FROM vouchers WHERE debit_account = c.account_code AND status != 'DRAFT'), 0)
        - 
        -- 3. المرتجعات الآجلة (تنقص ديون الزبون)
        COALESCE((SELECT SUM(total) FROM invoices WHERE customer_id = c.id AND payment_method = 'CREDIT' AND type = 'RETURN' AND status != 'DRAFT'), 0)
        - 
        -- 4. 🔴 التعديل هنا: أي سند يكون الزبون فيه دائناً (تنقص ديون الزبون لأنه دفع لنا)
        COALESCE((SELECT SUM(amount) FROM vouchers WHERE credit_account = c.account_code AND status != 'DRAFT'), 0)
      ) AS net_balance
      FROM customers c
      WHERE c.name LIKE ? OR c.account_code LIKE ?
      ORDER BY c.name ASC;
    ''';

    return db.customSelect(
      query,
      variables:[Variable.withString(searchTerm), Variable.withString(searchTerm)],
      readsFrom: {db.customers, db.invoices, db.vouchers},
    ).watch().map((rows) {
      return rows.map((row) {
        return CustomerWithBalance(
          customer: db.customers.map(row.data),
          netBalance: row.read<double>('net_balance'),
        );
      }).toList();
    });
  }

  // ─── تحديث حالة الزبائن بعد إرسال ملف الإكسيل ───
  Future<void> markUnsentAsSent() async {
    await (db.update(db.customers)
      ..where((t) => t.isSent.equals(false) | t.isModified.equals(true))
    ).write(
      // قمنا بإزالة كلمة const لتجنب أي خطأ، واستخدمنا Value مباشرة
      const CustomersCompanion(
        isSent: Value(true),
        isModified: Value(false),
      ),
    );
  }
}

final customersDaoProvider = Provider<CustomersDao>((ref) {
  return CustomersDao(ref.watch(databaseProvider));
});

// ─── كلاس مساعد لربط الزبون برصيده ───
class CustomerWithBalance {
  final Customer customer;
  final double netBalance;

  CustomerWithBalance({required this.customer, required this.netBalance});
}
