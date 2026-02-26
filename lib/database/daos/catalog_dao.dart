import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class CatalogDao {
  final AppDatabase db;
  CatalogDao(this.db);

  // ─── 1. إدارة المجموعات ─────────────────────────────

  // جلب المجموعات مرتبة حسب الحقل displayOrder
  Stream<List<ProductCategory>> watchCategories() {
    return (db.select(db.productCategories)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // إضافة مجموعة جديدة (تأخذ الترتيب الأخير تلقائياً)
  Future<void> addCategory(String name, int columns) async {
    final existing = await db.select(db.productCategories).get();
    await db.into(db.productCategories).insert(
      ProductCategoriesCompanion(
        name: Value(name),
        displayOrder: Value(existing.length),
        gridColumns: Value(columns),
      ),
    );
  }

  // تعديل اسم المجموعة أو عدد أعمدتها
  Future<void> updateCategory(ProductCategory category) async {
    await db.update(db.productCategories).replace(category);
  }

  // حفظ الترتيب الجديد للمجموعات (بعد السحب والإفلات)
  Future<void> updateCategoriesOrder(List<ProductCategory> orderedCategories) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedCategories.length; i++) {
        // نحدث رقم الترتيب (displayOrder) ليكون هو نفس موقعها في القائمة (i)
        await updateCategory(orderedCategories[i].copyWith(displayOrder: i));
      }
    });
  }

  // حذف المجموعة (يجب ألا تحتوي على مواد)
  Future<bool> deleteCategory(int categoryId) async {
    final productsCount = await (db.select(db.products)..where((t) => t.categoryId.equals(categoryId))).get();
    if (productsCount.isNotEmpty) return false; // لا يمكن الحذف إذا كان بداخلها مواد

    await (db.delete(db.productCategories)..where((t) => t.id.equals(categoryId))).go();
    return true;
  }

  // ─── 2. تهيئة البيانات الافتراضية ────────────────────
  Future<void> initDefaultCategories() async {
    final existing = await db.select(db.productCategories).get();
    if (existing.isEmpty) {
      await addCategory('الظروف', 2);
      await addCategory('الأكيال', 3);
      await addCategory('العلب والأكياس', 2);
    }
  }

  // ─── 3. إدارة المواد (المنتجات) ───────────────────────

  // جلب مواد مجموعة معينة مرتبة حسب الحقل displayOrder
  Stream<List<Product>> watchProductsByCategory(int categoryId) {
    return (db.select(db.products)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // إضافة مادة جديدة
  Future<int> insertProduct(ProductsCompanion product) async {
    return await db.into(db.products).insert(product);
  }

  // تحديث مادة موجودة
  Future<bool> updateProductDetails(Product product) async {
    return await db.update(db.products).replace(product);
  }

  // حفظ الترتيب الجديد للمواد (بعد السحب والإفلات)
  Future<void> updateProductsOrder(List<Product> orderedProducts) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedProducts.length; i++) {
        await db.update(db.products).replace(orderedProducts[i].copyWith(displayOrder: i));
      }
    });
  }

  // حذف مادة (في المستقبل سنتأكد إذا كانت مستخدمة في فاتورة أم لا)
  Future<int> deleteProduct(int id) {
    return (db.delete(db.products)..where((t) => t.id.equals(id))).go();
  }

  // جلب مادة واحدة حسب الـ ID (تُستخدم عند فتح المادة للتعديل)
  Future<Product?> getProductById(int id) {
    return (db.select(db.products)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}

// المزود (Provider)
final catalogDaoProvider = Provider<CatalogDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CatalogDao(db);
});