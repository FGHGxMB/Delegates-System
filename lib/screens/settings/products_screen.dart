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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        // إرسال ID المجموعة لصفحة الإضافة لكي تُربط المادة بها
        onPressed: () => context.push('/product_form/$categoryId/0'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children:[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(AppStrings.dragToReorder, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: dao.watchProductsByCategory(categoryId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final products = snapshot.data!;

                if (products.isEmpty) return const Center(child: Text(AppStrings.noData));

                return ReorderableListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: products.length,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = products.removeAt(oldIndex);
                    products.insert(newIndex, item);
                    await dao.updateProductsOrder(products); // حفظ الترتيب
                  },
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      key: ValueKey(product.id),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.drag_indicator, color: Colors.grey),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${product.code} | ${product.unit1Name} | ${product.unit1PriceRetail} ${product.currency}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primary),
                              // فتح المادة للتعديل (إرسال ID المادة)
                              onPressed: () => context.push('/product_form/$categoryId/${product.id}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(AppStrings.warning),
                                      content: const Text(AppStrings.deleteProductConfirm),
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}