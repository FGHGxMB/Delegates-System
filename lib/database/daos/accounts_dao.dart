import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class AccountsDao {
  final AppDatabase db;
  AccountsDao(this.db);

  // جلب الحسابات مرتبة حسب اختيارك
  Stream<List<Account>> watchAllAccounts() {
    return (db.select(db.accounts)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // إضافة أو تحديث حساب
  Future<void> saveAccount(Account account) async {
    await db.into(db.accounts).insertOnConflictUpdate(account);
  }

  // ترتيب الحسابات (السحب والإفلات)
  Future<void> updateAccountsOrder(List<Account> orderedAccounts) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedAccounts.length; i++) {
        await db.update(db.accounts).replace(orderedAccounts[i].copyWith(displayOrder: i));
      }
    });
  }

  // حذف حساب (ممنوع لحسابات النظام)
  Future<bool> deleteAccount(int id) async {
    final account = await (db.select(db.accounts)..where((t) => t.id.equals(id))).getSingle();
    if (account.isSystem) return false;
    await (db.delete(db.accounts)..where((t) => t.id.equals(id))).go();
    return true;
  }

  // زراعة الحسابات الافتراضية المحدثة
  Future<void> initDefaultAccounts() async {
    final existing = await db.select(db.accounts).get();
    if (existing.isEmpty) {
      final defaults =[
        AccountsCompanion(code: const Value('CASH_SYP'), name: const Value('الصندوق (ل.س)'), currency: const Value('SYP'), accountType: const Value('CASH'), isSystem: const Value(true), displayOrder: const Value(0)),
        AccountsCompanion(code: const Value('CASH_USD'), name: const Value('الصندوق (\$)'), currency: const Value('USD'), accountType: const Value('CASH'), isSystem: const Value(true), displayOrder: const Value(1)),
        AccountsCompanion(code: const Value('REV_MISC'), name: const Value('إيرادات مختلفة'), currency: const Value('BOTH'), accountType: const Value('REVENUE'), isSystem: const Value(true), displayOrder: const Value(2)),
        AccountsCompanion(code: const Value('EXP_MISC'), name: const Value('مصروفات مختلفة'), currency: const Value('BOTH'), accountType: const Value('EXPENSE'), isSystem: const Value(true), displayOrder: const Value(3)),
      ];
      for (var acc in defaults) {
        await db.into(db.accounts).insert(acc);
      }
    }
  }
}

final accountsDaoProvider = Provider<AccountsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return AccountsDao(db);
});