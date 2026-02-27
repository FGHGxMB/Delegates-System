import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database.dart';
import '../../providers/database_provider.dart';

class CatalogDao {
  final AppDatabase db;
  CatalogDao(this.db);

  // ─── 1. إدارة المجموعات ─────────────────────────────

  Stream<List<ProductCategory>> watchCategories() {
    return (db.select(db.productCategories)
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

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

  Future<void> updateCategory(ProductCategory category) async {
    await db.update(db.productCategories).replace(category);
  }

  Future<void> updateCategoriesOrder(List<ProductCategory> orderedCategories) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedCategories.length; i++) {
        await updateCategory(orderedCategories[i].copyWith(displayOrder: i));
      }
    });
  }

  Future<bool> deleteCategory(int categoryId) async {
    final productsCount = await (db.select(db.products)..where((t) => t.categoryId.equals(categoryId))).get();
    if (productsCount.isNotEmpty) return false;

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

  Stream<List<Product>> watchProductsByCategory(int categoryId) {
    return (db.select(db.products)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  Future<int> insertProduct(ProductsCompanion product) async {
    return await db.into(db.products).insert(product);
  }

  Future<bool> updateProductDetails(Product product) async {
    return await db.update(db.products).replace(product);
  }

  Future<void> updateProductsOrder(List<Product> orderedProducts) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedProducts.length; i++) {
        await db.update(db.products).replace(orderedProducts[i].copyWith(displayOrder: i));
      }
    });
  }

  Future<int> deleteProduct(int id) {
    return (db.delete(db.products)..where((t) => t.id.equals(id))).go();
  }

  Future<Product?> getProductById(int id) {
    return (db.select(db.products)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<bool> isCategoryNameExists(String name, int excludeId) async {
    final result = await (db.select(db.productCategories)
      ..where((t) => t.name.equals(name) & t.id.equals(excludeId).not()))
        .get();
    return result.isNotEmpty;
  }

  Future<bool> isProductCodeOrNameExists(String code, String name, int excludeId) async {
    final result = await (db.select(db.products)
      ..where((t) => (t.code.equals(code) | t.name.equals(name)) & t.id.equals(excludeId).not()))
        .get();
    return result.isNotEmpty;
  }

  Stream<List<Product>> watchActiveProductsByCategory(int categoryId) {
    return (db.select(db.products)
      ..where((t) => t.isActive.equals(true) & t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // ─── 4. دوال العواميد الجديدة (مصممة باحترافية الآن) ───

  // جلب العواميد التابعة لمجموعة معينة
  Future<List<ProductColumn>> getColumnsByCategory(int categoryId) {
    return (db.select(db.productColumns) // 👈 انظر، استخدمنا db.productColumns الصحيحة
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .get();
  }

  // التحقق هل يمكن حذف العمود؟ (لا يمكن إذا كان به مواد)
  Future<bool> canDeleteColumn(int columnId) async {
    final productsCount = await (db.select(db.products)..where((t) => t.columnId.equals(columnId))).get();
    return productsCount.isEmpty;
  }

  // التحقق هل يمكن حذف المجموعة؟ (لا يمكن إذا كان بها عواميد)
  Future<bool> canDeleteCategory(int categoryId) async {
    final columnsCount = await (db.select(db.productColumns)..where((t) => t.categoryId.equals(categoryId))).get();
    return columnsCount.isEmpty;
  }

  // ─── دوال عمليات العواميد (CRUD) ───────────────────────

  // إضافة عامود جديد
  Future<int> addColumn(int categoryId, String name) async {
    final existing = await getColumnsByCategory(categoryId);
    return await db.into(db.productColumns).insert(
      ProductColumnsCompanion(
        categoryId: Value(categoryId),
        name: Value(name),
        displayOrder: Value(existing.length), // ليكون في آخر الترتيب
        isVisible: const Value(true), // مرئي بشكل افتراضي
      ),
    );
  }

  // تعديل عامود (مثلاً تغيير اسمه أو إخفاؤه)
  Future<bool> updateColumn(ProductColumn column) async {
    return await db.update(db.productColumns).replace(column);
  }

  // تحديث ترتيب العواميد (عند السحب والإفلات)
  Future<void> updateColumnsOrder(List<ProductColumn> orderedColumns) async {
    await db.transaction(() async {
      for (int i = 0; i < orderedColumns.length; i++) {
        await updateColumn(orderedColumns[i].copyWith(displayOrder: i));
      }
    });
  }

  // حذف العامود (مع التحقق من عدم وجود مواد فيه)
  Future<bool> deleteColumn(int columnId) async {
    final canDelete = await canDeleteColumn(columnId);
    if (!canDelete) return false; // لا يمكن الحذف لوجود مواد

    await (db.delete(db.productColumns)..where((t) => t.id.equals(columnId))).go();
    return true;
  }

  // تعديل دالة حذف المجموعة (لتتوافق مع المنطق الجديد)
  // لا يمكن حذف مجموعة فيها مواد، ولكن إن كانت فارغة تُحذف وتُحذف عواميدها الفارغة معها
  Future<bool> deleteCategoryWithColumns(int categoryId) async {
    // 1. هل يوجد بها مواد؟
    final productsCount = await (db.select(db.products)..where((t) => t.categoryId.equals(categoryId))).get();
    if (productsCount.isNotEmpty) return false;

    // 2. إذا لم يكن بها مواد، نحذف عواميدها ثم نحذفها
    await db.transaction(() async {
      await (db.delete(db.productColumns)..where((t) => t.categoryId.equals(categoryId))).go();
      await (db.delete(db.productCategories)..where((t) => t.id.equals(categoryId))).go();
    });
    return true;
  }

  // تبديل حالة إخفاء/إظهار المجموعة
  Future<void> toggleCategoryVisibility(ProductCategory category) async {
    await db.update(db.productCategories).replace(
        category.copyWith(isVisible: !category.isVisible)
    );
  }

  // تبديل حالة إخفاء/إظهار العمود
  Future<void> toggleColumnVisibility(ProductColumn column) async {
    await db.update(db.productColumns).replace(
        column.copyWith(isVisible: !column.isVisible)
    );
  }

  // مراقبة العواميد الحية لمجموعة معينة (للاستخدام في واجهة المستخدم)
  Stream<List<ProductColumn>> watchColumnsByCategory(int categoryId) {
    return (db.select(db.productColumns)
      ..where((t) => t.categoryId.equals(categoryId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // ─── دوال شاشة اختيار المواد (للفواتير) ────────────────

  // 1. جلب المجموعات "المرئية" فقط
  Stream<List<ProductCategory>> watchVisibleCategories() {
    return (db.select(db.productCategories)
      ..where((t) => t.isVisible.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // 2. جلب العواميد "المرئية" التابعة لمجموعة معينة
  Stream<List<ProductColumn>> watchVisibleColumnsByCategory(int categoryId) {
    return (db.select(db.productColumns)
      ..where((t) => t.categoryId.equals(categoryId) & t.isVisible.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // 3. جلب المواد "الفعالة" التابعة لعامود معين
  Stream<List<Product>> watchActiveProductsByColumn(int columnId) {
    return (db.select(db.products)
    // نفترض أنك أضفت حقل columnId في جدول المنتجات، إذا كان اسمه مختلفاً عدله هنا
      ..where((t) => t.isActive.equals(true) & t.columnId.equals(columnId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }

  // جلب كل المواد (الفعالة والمعطلة) التابعة لعامود معين لغرض شاشة الإعدادات
  Stream<List<Product>> watchAllProductsByColumn(int columnId) {
    return (db.select(db.products)
      ..where((t) => t.columnId.equals(columnId))
      ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
        .watch();
  }
}

// المزود (Provider)
final catalogDaoProvider = Provider<CatalogDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CatalogDao(db);
});