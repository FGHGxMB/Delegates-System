import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/catalog_dao.dart';
import '../../database/database.dart';

class ProductsScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const ProductsScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(catalogDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.manageProducts} - $categoryName'),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        // إرسال ID المجموعة لصفحة الإضافة لكي تُربط المادة بها
        onPressed: () => context.push('/product_form/$categoryId/0'),
        child: const Icon(Icons.add),
      ),

      // استخدمنا FutureBuilder لجلب معلومات المجموعة لمعرفة عدد الأعمدة (gridColumns)
      body: FutureBuilder<ProductCategory?>(
        future: (dao.db.select(dao.db.productCategories)..where((t) => t.id.equals(categoryId))).getSingleOrNull(),
        builder: (context, catSnapshot) {
          if (catSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // تحديد عدد الأعمدة، وإذا كان 0 نجعله 2 كافتراضي
          final columnsCount = (catSnapshot.data?.gridColumns ?? 2) > 0 ? catSnapshot.data!.gridColumns : 2;

          return StreamBuilder<List<Product>>(
            stream: dao.watchProductsByCategory(categoryId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final products = snapshot.data!;

              if (products.isEmpty) return const Center(child: Text(AppStrings.noData));

              return GridView.builder(
                padding: const EdgeInsets.all(8).copyWith(bottom: 80),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnsCount,
                  mainAxisExtent: 120, // 👈 ارتفاع ثابت للبطاقة يمنع الخطأ الأحمر نهائياً
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    key: ValueKey(product.id),
                    elevation: 2,
                    // تظليل المادة بالرمادي إذا كانت معطلة
                    color: product.isActive ? Colors.white : Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: product.isActive ? Colors.grey.shade300 : Colors.red.shade200,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          // اسم المادة مع تصغير تلقائي للخط
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: product.isActive ? TextDecoration.none : TextDecoration.lineThrough, // خط على الاسم إذا كانت معطلة
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // السعر والكود مع تصغير تلقائي
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${product.code} | ${product.unit1PriceRetail} ${product.currency}',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                          const Divider(height: 8),
                          // أزرار التعديل والحذف
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.edit, color: AppColors.primary, size: 22),
                                onPressed: () => context.push('/product_form/$categoryId/${product.id}'),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(AppStrings.warning),
                                        content: const Text('هل أنت متأكد من حذف هذه المادة؟'),
                                        actions:[
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.no)),
                                          FilledButton(
                                              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                              onPressed: () => Navigator.pop(ctx, true),
                                              child: const Text(AppStrings.yes)
                                          ),
                                        ],
                                      )
                                  );
                                  if (confirm == true) await dao.deleteProduct(product.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}