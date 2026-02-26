import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class CategoriesDao {
  final AppDatabase db;

  CategoriesDao(this.db);

  // جلب المجموعات مرتبة حسب (displayOrder)
  Stream<List<ProductCategory>> watchCategories() {
    return (db.select(db.productCategories)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // إضافة مجموعة مع تحديد عدد أعمدة العرض
  Future<int> insertCategory(String name, int columns) {
    return db.into(db.productCategories).insert(
        ProductCategoriesCompanion(name: Value(name), gridColumns: Value(columns))
    );
  }

  // تحديث بيانات المجموعة (اسمها وعدد أعمدتها)
  Future<void> updateCategory(int id, String name, int columns) {
    return (db.update(db.productCategories)..where((t) => t.id.equals(id))).write(
        ProductCategoriesCompanion(name: Value(name), gridColumns: Value(columns))
    );
  }

  // تحديث ترتيب المجموعات (للسحب والإفلات لاحقاً)
  Future<void> updateCategoryOrder(int id, int newOrder) {
    return (db.update(db.productCategories)..where((t) => t.id.equals(id))).write(
        ProductCategoriesCompanion(displayOrder: Value(newOrder))
    );
  }

  // حذف مجموعة (مع التحقق من عدم وجود مواد بداخلها)
  Future<bool> deleteCategory(int id) async {
    final count = await (db.select(db.products)..where((t) => t.categoryId.equals(id))).get();
    if (count.isNotEmpty) return false; // لا يمكن الحذف لوجود مواد!

    await (db.delete(db.productCategories)..where((t) => t.id.equals(id))).go();
    return true;
  }
}

final categoriesDaoProvider = Provider<CategoriesDao>((ref) {
  return CategoriesDao(ref.watch(databaseProvider));
});