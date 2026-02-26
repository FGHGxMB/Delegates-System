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

  // ─── [جديد] حماية الحذف ───
  Future<bool> deleteCustomer(int id) async {
    final invoicesCount = await (db.select(db.invoices)..where((t) => t.customerId.equals(id))).get();
    if (invoicesCount.isNotEmpty) return false; // ممنوع الحذف لوجود فواتير
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
}

final customersDaoProvider = Provider<CustomersDao>((ref) {
  return CustomersDao(ref.watch(databaseProvider));
});