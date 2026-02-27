import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../database/daos/catalog_dao.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import 'product_form_screen.dart'; // تأكد من مسار الشاشة

class ProductsScreen extends ConsumerWidget {
  final int categoryId;
  final int columnId;
  final String columnName;

  const ProductsScreen({
    Key? key,
    required this.categoryId,
    required this.columnId,
    required this.columnName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogDao = ref.watch(catalogDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('مواد: $columnName'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Product>>(
        stream: catalogDao.watchAllProductsByColumn(columnId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ??[];

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد مواد في هذا العامود.'));
          }

          return ReorderableListView.builder(
            itemCount: products.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = products.removeAt(oldIndex);
              products.insert(newIndex, item);
              catalogDao.updateProductsOrder(products); // تحديث الترتيب
            },
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                key: ValueKey(product.id),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: product.isActive ? Colors.white : Colors.grey.shade300,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const Icon(Icons.drag_indicator, color: Colors.grey),
                  title: Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: product.isActive ? null : TextDecoration.lineThrough,
                      color: product.isActive ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  subtitle: Text('الرمز: ${product.code} | السعر: ${product.unit1PriceRetail}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      // زر التعديل
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductFormScreen(categoryId: categoryId, productId: product.id), // فتح المادة للتعديل
                            ),
                          );
                        },
                      ),
                      // زر الحذف
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeleteProduct(context, catalogDao, product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // الدخول لشاشة إضافة مادة جديدة
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductFormScreen(categoryId: categoryId, productId: 0)),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('مادة جديدة', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _confirmDeleteProduct(BuildContext context, CatalogDao dao, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.warning),
        content: Text('هل أنت متأكد من حذف المادة "${product.name}"؟\nلا يمكن الحذف إذا كانت مستخدمة في أي فاتورة.'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.no)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await dao.deleteProduct(product.id);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح')));
                }
              } catch (e) {
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يمكن الحذف! المادة مستخدمة. قم بتعطيلها من شاشة التعديل.'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text(AppStrings.yes),
          ),
        ],
      ),
    );
  }
}