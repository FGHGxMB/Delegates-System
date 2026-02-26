import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class WarehousesDao {
  final AppDatabase db;

  WarehousesDao(this.db);

  // جلب جميع المستودعات كـ Stream (ليتحدث الـ UI تلقائياً عند أي تغيير)
  Stream<List<Warehouse>> watchAllWarehouses() {
    return db.select(db.warehouses).watch();
  }

  // جلب جميع المستودعات كـ Future (للاستخدام لمرة واحدة)
  Future<List<Warehouse>> getAllWarehouses() {
    return db.select(db.warehouses).get();
  }

  // إضافة مستودع جديد
  Future<int> addWarehouse(String name) {
    return db.into(db.warehouses).insert(
      WarehousesCompanion(name: Value(name)),
      mode: InsertMode.insertOrIgnore, // تجاهل إذا كان الاسم موجوداً مسبقاً
    );
  }

  // حذف مستودع
  Future<void> deleteWarehouse(int id) {
    return (db.delete(db.warehouses)..where((tbl) => tbl.id.equals(id))).go();
  }
}

// مزود (Provider) خاص بالمستودعات
final warehousesDaoProvider = Provider<WarehousesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return WarehousesDao(db);
});